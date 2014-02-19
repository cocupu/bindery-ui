# describe "service: BinderySearchService", ->
# 
#   Given -> module('app')
# 
#   Given -> inject ($http, @SearchService, @ContextService) =>
#    	@$httpGet  = spyOn($http, 'get')
# 		@ContextService.identityName = "testperson"
# 		@ContextService.poolName = "apool"
# 
# 
#   describe "#runQuery", ->
#     Given		-> @queryParams = {q: 'Trees', facets: {author_t:"Bob", date_t:"09-18-2009"}, numRows:25, start:0}
# 		And			-> @BinderySearchService.queryParams = @queryParams
# 		When		-> @BinderySearchService.runQuery()
# 		Then		-> expect(@$httpGet).toHaveBeenCalledWith('/testperson/apool/search', @queryParams)
# 
#   describe "#lastQuery should retain last query", ->
# 		Given  -> @queryParams = {q: 'Trees', facets: {author_t:"Bob", date_t:"09-18-2009"}, numRows:25, start:0}
# 		And 	 -> @BinderySearchService.queryParams = @queryParams
# 		When   -> @BinderySearchService.runQuery()
# 		Then   -> expect(@BinderySearchService.lastQuery).toEqual(@queryParams)
# 		And   -> expect(@BinderySearchService.lastQuery.q).toEqual('Trees')
# 		When   -> @BinderySearchService.queryParams.q = "Buddha"
# 		And   -> @BinderySearchService.setFacet("author_t", "Atul")
# 		Then   -> expect(@BinderySearchService.lastQuery).toEqual(@queryParams)
# 		When   -> @BinderySearchService.runQuery()
# 		Then   -> expect(@BinderySearchService.lastQuery).not.toEqual(@queryParams)
# 		And   -> expect(@BinderySearchService.lastQuery.q).toEqual("Buddha")
# 		And   -> expect(@BinderySearchService.lastQuery.facets.author_t).toEqual("Atul")
#     
