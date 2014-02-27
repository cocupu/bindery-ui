describe "service: BinderySearchService", ->

  Given -> module("app")
      
  Given -> module ($provide) -> 
    $provide.constant('ContextService', {"binderyBaseUrl":"localhost:5555", "poolUrl":"/fooId/barPool"}) 
	
  Given -> inject (@ContextService, $http, @BinderySearchService) =>
    @$httpPost = spyOn($http, 'post')
    @$httpGet  = spyOn($http, 'get')

  describe "#queryParams", ->
    Then   -> expect(@BinderySearchService.queryParams.page).toBe(1)
    Then   -> expect(@BinderySearchService.queryParams.rows).toBe(25)
		
  describe "#runQuery", ->
    # When -> @BinderySearchService.runQuery(25, 0, "")
    # Then -> expect(@$httpGet.calls).toBe("")
    # Then -> expect(@$httpGet).toHaveBeenCalledWith('localhost:5555/fooId/barPool', {"rows":25, page:1, q:""})
