class BinderySearchService extends AngularService
  @register angular.module('curateDeps')
  @inject 'ContextService', 'BinderyServer', 'BinderyNode', '$http'
	
	#
	# Default Property Values
	#
  pagingOptions: 
    pageSizes: [25, 50, 100, 250, 500, 1000]
    pageSize: 25
    currentPage: 1
      
  totalServerItems: 0
  searchResponse: {}
  docs: []
  selectedNode: {}
  queryString: ""
  sorting: []
  facetConstraints: []
  facets: {}
  
  #
  # Methods
  #
  
  # Run query against DataBindery
  runQuery: () -> 
    # setTimeout( (() =>
    if (@queryString)
      @queryString = @queryString.toLowerCase()
    else
      @queryString = ""
    @$http.get(@BinderyServer.baseUrl + @ContextService.poolUrl+ "/search.json", {
      params: @queryParams()
    }).success( (data) =>
      @processResults(data);
    )
    # ), 100)
  
  # Process results from DataBindery, setting searchResponse, docs and totalServerItems on the service  
  processResults: (data) ->
    angular.forEach(data.docs, (item, idx) =>
      data.docs[idx] =  new @BinderyNode(item)  #<-- replace each item with an instance of the resource object
    )
    @searchResponse = data
    @docs = data.docs
    @totalServerItems = data.response.numFound
    @parseFacets()
    
  # Wrangles the BinderyService's current properties for submitting as params on your HTTP query to DataBindery   
  # @returns a js object with "rows", "page", "q" and (optionally) "model_id"      
  queryParams: () -> 
    params = {
      rows: @pagingOptions.pageSize,
      page: @pagingOptions.currentPage,
      q: @queryString
    }
    if(@sorting.length > 0)
      sortFields = $.map(@sorting, (entry) ->
        obj = {}
        obj[entry.field.id] = entry.direction
        return obj
      )
      params["sort_fields"] = JSON.stringify(sortFields)
    if(@facetConstraints.length > 0)
      angular.forEach(@facetConstraints, (entry, idx) ->
        params["f["+entry.fieldName+"][]"] = entry.value
      )
    unless (typeof @model_id == "undefined")
      params.model_id = @model_id
    return params

  addFacetFilter: (facetFieldName, filterValue) ->
    newConstraint = {fieldName:facetFieldName, value:filterValue}
    @facetConstraints = @facetConstraints.concat(newConstraint)
    @runQuery()

  removeFacetFilter: (facetFieldName, filterValue) ->
    @facetConstraints = @facetConstraints.filter( (entry) ->  return entry.fieldName != facetFieldName || entry.value != filterValue )
    @runQuery()
    
  isConstrainingBy: (facetFieldName, filterValue=undefined) ->
    @facetConstraints.filter( (entry) ->  return entry.fieldName == facetFieldName && (entry.value == filterValue || filterValue==undefined) ).length > 0

  constraintsFor: (facetFieldName) ->
    @facetConstraints.filter( (entry) ->  return entry.fieldName == facetFieldName ) 

  facetValuesFor: (facetFieldName) ->
    values = @facets[facetFieldName]
    if values == undefined
      if @isConstrainingBy(facetFieldName)
        return $.map(@constraintsFor(facetFieldName), (constraint) -> 
          return {value: constraint.value}
        )
      else
        return []
    else
      return values

  addSortField: (field_id, direction) ->
    currentFields = $.map(@sorting, (entry) -> return entry.field.id )
    # Do nothing if the requested sort is already set
    if currentFields.indexOf(field_id) > -1 && @sorting[currentFields.indexOf(field_id)].direction == direction
      return true
    else
      filtered = @sorting.filter( (sortEntry) ->  return sortEntry.field.id != field_id )
      @sorting = [{field:{id:field_id}, direction:direction}].concat(filtered)

  # Parse solr's facet field array into an array of facetField objects
  parseFacets: () ->
    if @searchResponse.facet_counts
      facet_fields = @searchResponse.facet_counts.facet_fields
    if typeof(facet_fields) != "undefined"
      updatedFacets = {}
      angular.forEach(facet_fields, (solrFacetValuesArray, facetName, obj) ->
        facetValues = $.map(solrFacetValuesArray, (ff,i) ->
          if (i%2 == 0)
            return {value: ff, count: solrFacetValuesArray[i+1]}
        )
        if facetValues.length > 0
          updatedFacets[facetName] = facetValues
      )
    else
      updatedFacets = []
      
    angular.forEach(@facetConstraints, (constraint) ->
      if updatedFacets[constraint.fieldName] == undefined
        updatedFacets[constraint.fieldName] = [{value:constraint.value}]
    )
    return @facets = updatedFacets

  removeSortField: (fieldId) ->
    @sorting = @sorting.filter( (entry) ->  return entry.field.id != fieldId )
  
  toggleSortDirection: (sort) ->
    if sort.direction == "asc"
      @addSortField(sort.field.id, "desc")
    else
      @addSortField(sort.field.id, "asc")