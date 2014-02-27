class BinderySearchService extends AngularService
	@register angular.module('curateDeps')
	@inject 'ContextService', '$http'
	
	constructor: () ->
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

	processResults: (data, page, pageSize) ->
    angular.forEach(data.docs, (item, idx) ->
      data.docs[idx] = new BinderyNode(item)  #<-- replace each item with an instance of the resource object
    )
    @searchResponse = data
    @docs = data.docs
    @totalServerItems = data.response.numFound

  runQuery: () ->
    
    setTimeout( (() ->
      if (searchText)
        ft = searchText.toLowerCase()
      else
        ft = ""
      @$http.get(@ContextService.binderyBaseUrl + @ContextService.poolUrl, {
        params: @queryParams
      }).success( (data) ->
        setPagingData(data,@queryParams.page,@queryParams.rows);
      )
    ), 100)
	
# angular.module('curateDeps').service('BinderySearchService', ['ContextService', '$http', BinderySearchService])