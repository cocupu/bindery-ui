describe "service: BinderySearchService", ->

  Given -> module("app")
	# Given -> module ($provide) =>
	# 	$provide.value("contextService", {"poolUrl":"/fooId/barPool"})
	
  Given -> inject ($http, @BinderySearchService) =>
		# @BinderySearchService.context.initialize("foo", "poolBar") 
    @$httpPost = spyOn($http, 'post')
    @$httpGet  = spyOn($http, 'get')

  describe "#queryParams", ->
    Then   -> expect(@BinderySearchService.queryParams.page).toBe(1)
    Then   -> expect(@BinderySearchService.queryParams.rows).toBe(25)
		
  describe "#runQuery", ->
    When -> @BinderySearchService.runQuery()
    # Then -> expect(@$httpPost).toHaveBeenCalledWith('/fooId/barPool', {"rows":25})
