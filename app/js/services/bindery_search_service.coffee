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
    
  # Wrangles the BinderyService's current properties for submitting as params on your HTTP query to DataBindery   
  # @returns a js object with "rows", "page", "q" and (optionally) "model_id"      
  queryParams: () -> 
    params = {
      rows: @pagingOptions.pageSize,
      page: @pagingOptions.currentPage,
      q: @queryString
    }
    if(@sorting.length > 0)
      params.sort = $.map(@sorting, (sort, i) -> return sort.field.code + " " +sort.direction ).join()
    unless (typeof @model_id == "undefined")
      params.model_id = @model_id
    return params

  addSortField: (field, direction) ->
    filtered = @sorting.filter( (sortEntry) ->  return typeof(sortEntry[field]) == 'undefined' )
    sortEntry = {}
    sortEntry[field] = direction
    @sorting = [sortEntry].concat(filtered)
