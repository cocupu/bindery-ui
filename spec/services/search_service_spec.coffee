describe "service: BinderySearchService", ->

  Given -> module("app")
  
  Given -> module ($provide) -> 
    $provide.constant('ContextService', {"binderyBaseUrl":"http://localhost:5555", "poolUrl":"/fooId/barPool"}) 
  
  Given -> inject ($http, @$httpBackend, ContextService, BinderyNode, @BinderySearchService) =>
    @$httpGet  = spyOn($http, 'get').andCallThrough()
    @sampleResponse = {docs:[{id:1, model_id:5}], response:{numFound:0}}
#    $httpBackend.when('GET', 'http://localhost:5555/fooId/barPool/search.json?model_id=4&page=1&q=Nina&rows=25').respond(@sampleResponse);
    $httpBackend.when('GET', 'http://localhost:5555/fooId/barPool/search.json?model_id=4&page=1&q=&rows=25').respond(@sampleResponse);
    $httpBackend.when('GET', 'http://localhost:5555/fooId/barPool/search.json?model_id=4&page=1&q=nina&rows=25').respond(@sampleResponse);
    $httpBackend.when('GET', 'http://localhost:5555/fooId/barPool/search.json?model_id=4&page=1&q=&rows=25&sort=title+asc,date+desc').respond(@sampleResponse);

  describe "#queryParams()", ->
    Then  -> expect(@BinderySearchService.queryParams().page).toBe(1)
    Then  -> expect(@BinderySearchService.queryParams().rows).toBe(25)
		Then  -> expect(@BinderySearchService.queryParams().model_id).toBe(@BinderySearchService.model_id)
		
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
    When  -> @BinderySearchService.sorting = [{field: {code:"title"}, direction:"asc"}, {field:{code:"date"}, direction:"desc"}]
    When  -> @BinderySearchService.runQuery()
    Then  -> expect(@$httpGet).toHaveBeenCalledWith('http://localhost:5555/fooId/barPool/search.json', {"params": {"rows":25, page:1, model_id: 4, q:"", sort:"title asc,date desc"}, method : 'get', url : 'http://localhost:5555/fooId/barPool/search.json'})
    When  -> @$httpBackend.flush()

  describe "#processResults", ->
    When  -> @BinderySearchService.processResults(@sampleResponse)
    Then  -> expect(@BinderySearchService.totalServerItems).toBe(0)
