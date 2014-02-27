class BinderySearchService extends AngularService
  @register angular.module('curateDeps')
  @inject 'ContextService', 'BinderyNode', '$http'
	
  initialize: () ->
    @pagingOptions = {
      pageSizes: [25, 50, 100, 250, 500, 1000],
      defaultPageSize: 25
    }
    @totalServerItems = 0
    @queryParams = {
      rows: @pagingOptions.defaultPageSize,
      page: 1,
      q: ""
    }
    @searchResponse = {}
    @docs = []
    @selectedNode = {}
  
  runQuery: () -> 
    # setTimeout( (() =>
    if (@queryParams.q)
      @queryParams.q = @queryParams.q.toLowerCase()
    else
      @queryParams.q = ""
    @$http.get(@ContextService.binderyBaseUrl + @ContextService.poolUrl, {
      params: @queryParams
    }).success( (data) =>
      @processResults(data);
    )
    # ), 100)
    
  processResults: (data) ->
    angular.forEach(data.docs, (item, idx) ->
      console.log(@BinderyNode)
      data.docs[idx] = new @BinderyNode(item)  #<-- replace each item with an instance of the resource object
    )
    @searchResponse = data
    @docs = data.docs
    @totalServerItems = data.response.numFound