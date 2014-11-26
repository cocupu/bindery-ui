describe "service: BinderySearchService", ->

  Given -> module("app")
  
  Given -> module ($provide) -> 
    $provide.constant('BinderyServer', {"baseUrl":"http://localhost:5555"}) 
    $provide.constant('ContextService', {"poolUrl":"/fooId/barPool"}) 

  
  Given -> inject ($http, @$httpBackend, ContextService, BinderyNode, @BinderySearchService) =>
    @$httpGet  = spyOn($http, 'get').andCallThrough()
    @sampleResponse = {docs:[{id:1, model_id:5}], response:{numFound:0}}
#    $httpBackend.when('GET', 'http://localhost:5555/fooId/barPool/search.json?model_id=4&page=1&q=Nina&rows=25').respond(@sampleResponse);
    $httpBackend.when('GET', 'http://localhost:5555/fooId/barPool/search.json?model_id=4&page=1&q=&rows=25').respond(@sampleResponse);
    $httpBackend.when('GET', 'http://localhost:5555/fooId/barPool/search.json?model_id=4&page=1&q=nina&rows=25').respond(@sampleResponse);
    $httpBackend.when('GET', 'http://localhost:5555/fooId/barPool/search.json?model_id=4&page=1&q=&rows=25&sort_fields=%5B%7B%2222%22:%22asc%22
%7D,%7B%2246%22:%22desc%22%7D%5D').respond(@sampleResponse);

  describe "#queryParams() defaults", ->
    Then  -> expect(@BinderySearchService.queryParams().page).toBe(1)
    Then  -> expect(@BinderySearchService.queryParams().rows).toBe(25)
		Then  -> expect(@BinderySearchService.queryParams().model_id).toBe(@BinderySearchService.model_id)

  describe "#queryParams() handling of sort entries", ->
    When  -> @BinderySearchService.sorting = [{field:{id:22},direction:"desc"},{field:{id:87},direction:"asc"}]
    Then  -> expect(@BinderySearchService.queryParams().sort_fields).toBe('[{"22":"desc"},{"87":"asc"}]')

  describe "#runQuery", ->
    When  -> spyOn(@BinderySearchService, 'processResults')
    When  -> @BinderySearchService.model_id = 4
    When  -> @BinderySearchService.queryString = "Nina"
    When  -> @BinderySearchService.runQuery()
    Then  -> expect(@$httpGet).toHaveBeenCalledWith('http://localhost:5555/fooId/barPool/search.json', {"params": {"rows":25, page:1, model_id: 4, q:"nina"}, method : 'get', url : 'http://localhost:5555/fooId/barPool/search.json'})
    When  -> @$httpBackend.flush()
    Then  -> expect(@BinderySearchService.processResults).toHaveBeenCalledWith(@sampleResponse)

  describe "#runQuery sorting", ->
    When  -> spyOn(@BinderySearchService, 'processResults')
    When  -> @BinderySearchService.model_id = 4
    When  -> @BinderySearchService.sorting = [{field: {id:22}, direction:"asc"}, {field:{id:46}, direction:"desc"}]
    When  -> @BinderySearchService.runQuery()
    Then  -> expect(@$httpGet).toHaveBeenCalledWith('http://localhost:5555/fooId/barPool/search.json', {"params": {"rows":25, page:1, model_id: 4, q:"", sort_fields: JSON.stringify([{"22":"asc"},{"46":"desc"}])}, method : 'get', url : 'http://localhost:5555/fooId/barPool/search.json'})
    When  -> @$httpBackend.flush()

  describe "#processResults", ->
    When  -> @BinderySearchService.processResults(@sampleResponse)
    Then  -> expect(@BinderySearchService.totalServerItems).toBe(0)

  describe "#addSortField constructs a sort entry in .sorting array", ->
    When  -> @BinderySearchService.addSortField(55,"desc")
    Then  -> expect(@BinderySearchService.sorting.toString()).toBe([ { field : { id : 55 }, direction : 'desc' } ].toString())

  describe "#addSortField prepends new fields to the array", ->
    When  -> @BinderySearchService.addSortField(55,"desc")
    When  -> @BinderySearchService.addSortField(86,"asc")
    Then  -> expect(@BinderySearchService.sorting.toString()).toBe([{field:{id:86},direction:"asc"},{field:{id:55},direction:"desc"}].toString())

  describe "#addSortField updates rather than repeats fields when switching the sort direction", ->
    When  -> @BinderySearchService.addSortField(55,"desc")
    When  -> @BinderySearchService.addSortField(86,"asc")
    When  -> @BinderySearchService.addSortField(55,"asc")
    Then  -> expect(@BinderySearchService.sorting.toString()).toBe([{field:{id:55},direction:"asc"},{field:{id:86},direction:"asc"}].toString())