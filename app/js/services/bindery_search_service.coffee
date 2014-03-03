class BinderySearchService extends AngularService
  @register angular.module('curateDeps')
  @inject 'ContextService', 'BinderyNode', '$http'
	
  initialize: () ->
    @pagingOptions = {
      pageSizes: [25, 50, 100, 250, 500, 1000],
      pageSize: 25,
      currentPage: 1
    }
    @totalServerItems = 0
    @searchResponse = {}
    @docs = []
    @selectedNode = {}
    @queryString = ""
    @model_id = 4
    
  queryParams: () -> {
    model_id: @model_id,
    rows: @pagingOptions.pageSize,
    page: @pagingOptions.currentPage,
    q: @queryString
  } 

    
  runQuery: () -> 
    # setTimeout( (() =>
    if (@queryString)
      @queryString = @queryString.toLowerCase()
    else
      @queryString = ""
    @$http.get(@ContextService.binderyBaseUrl + @ContextService.poolUrl+ "/search.json", {
      params: @queryParams()
    }).success( (data) =>
      @processResults(data);
    )
    # ), 100)
    
  processResults: (data) ->
    angular.forEach(data.docs, (item, idx) =>
      data.docs[idx] =  new @BinderyNode(item)  #<-- replace each item with an instance of the resource object
    )
    @searchResponse = data
    @docs = data.docs
    @totalServerItems = data.response.numFound