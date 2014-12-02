describe "service: BinderySearchService", ->

  Given -> module("app")
  
  Given -> module ($provide) -> 
    $provide.constant('BinderyServer', {"baseUrl":"http://localhost:5555"}) 
    $provide.constant('ContextService', {"poolUrl":"/fooId/barPool"}) 

  
  Given -> inject ($http, @$httpBackend, ContextService, BinderyNode, @BinderySearchService) =>
    @$httpGet  = spyOn($http, 'get').andCallThrough()
    @sampleResponse = {docs:[{id:1, model_id:5}], response:{numFound:0}}
    @sampleResponseWithFacets = {docs:[{id:1, model_id:5}], response:{numFound:1000}, facet_counts:{facet_fields:{"model_name":["url",10763],"date_ssi":["2014-08-28",4019,"2014-08-23",2639,"2014-08-27",1961,"2014-08-30",1218,"2014-09-01",257,"2014-08-29",225,"2014-08-24",190,"2014-08-26",177,"2014-08-25",77],"posted_time_dtsi":["2014-08-28T19:52:05Z",6,"2014-08-23T10:22:34Z",5,"2014-08-23T05:00:19Z",4,"2014-08-23T09:30:08Z",4,"2014-08-23T09:44:07Z",4,"2014-08-23T18:00:11Z",4,"2014-08-24T23:51:34Z",4,"2014-08-27T08:56:09Z",4,"2014-08-27T23:11:07Z",4,"2014-08-28T00:15:17Z",4,"2014-08-28T03:54:06Z",4],"postproduction_notes_ssi":[],"source_urls_tesim":["http",10762,"t.co",10762,"smm918wo8",7,"jk2iflfi3p",6,"65dsvpayaf",5,"7rrp7giuei",5,"0fhyq0r8ft",4,"12szwostnt",4,"2ln70eckhm",4,"2nvlctatuz",4,"6bgvw9nqnn",4],"text_tesim":["http",10745,"t.co",10694,"rt",5902,"javascript",4147,"html5",3162,"jqueri",1573,"css3",1278,"develop",1236,"angularj",991,"us",979,"via",950],"total_tweets_isi":["1",4330,"3",2142,"6",1177,"2",651,"10",442,"4",239,"9",185,"5",155,"15",154,"7",150,"12",120],"url_ssi":["http://antjanus.com/blog/web-development-tutorials/front-end-development/comprehensive-beginner-guide-angularjs",8,"http://42yo.com",7,"http://antjanus.com:80/blog/web-development-tutorials/front-end-development/comprehensive-beginner-guide-angularjs/?",7,"http://appdevelopermagazine.com/1700/2014/7/25/monaca-updates-its-mobile-app-html5-ui-framework-now-with-jquery-support",7,"http://ay.gy:80/rahy6?",7,"http://bjorn.tipling.com/advanced-objects-in-javascript",7,"http://blog.andyet.com/2014/08/13/opinionated-rundown-of-js-frameworks",7,"http://cashclamber.com",7,"http://ariya.ofilabs.com/2014/08/phantomjs-2-and-javascript-goodies.html",6,"http://avocode.com",6,"http://bjorn.tipling.com:80/advanced-objects-in-javascript?",6]}}}
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
    And  -> @BinderySearchService.model_id = 4
    And  -> @BinderySearchService.queryString = "Nina"
    And  -> @BinderySearchService.runQuery()
    Then  -> expect(@$httpGet).toHaveBeenCalledWith('http://localhost:5555/fooId/barPool/search.json', {"params": {"rows":25, page:1, model_id: 4, q:"nina"}, method : 'get', url : 'http://localhost:5555/fooId/barPool/search.json'})
    When  -> @$httpBackend.flush()
    Then  -> expect(@BinderySearchService.processResults).toHaveBeenCalledWith(@sampleResponse)

  describe "#runQuery sorting", ->
    When  -> spyOn(@BinderySearchService, 'processResults')
    And  -> @BinderySearchService.model_id = 4
    And  -> @BinderySearchService.sorting = [{field: {id:22}, direction:"asc"}, {field:{id:46}, direction:"desc"}]
    And  -> @BinderySearchService.runQuery()
    Then  -> expect(@$httpGet).toHaveBeenCalledWith('http://localhost:5555/fooId/barPool/search.json', {"params": {"rows":25, page:1, model_id: 4, q:"", sort_fields: JSON.stringify([{"22":"asc"},{"46":"desc"}])}, method : 'get', url : 'http://localhost:5555/fooId/barPool/search.json'})
    When  -> @$httpBackend.flush()

  describe "#processResults", ->
    When  -> @BinderySearchService.processResults(@sampleResponse)
    Then  -> expect(@BinderySearchService.totalServerItems).toBe(0)

  describe "#addSortField constructs a sort entry in .sorting array", ->
    When  -> @BinderySearchService.addSortField(55,"desc")
    Then  -> expect(@BinderySearchService.sorting.toString()).toBe([ { field : { id : 55 }, direction : 'desc' } ].toString())
    Then  -> expect(@BinderySearchService.runQuery).toHaveBeenCalled
    
  describe "#addSortField prepends new fields to the array", ->
    When  -> @BinderySearchService.addSortField(55,"desc")
    And  -> @BinderySearchService.addSortField(86,"asc")
    Then  -> expect(@BinderySearchService.sorting).toEqual([{field:{id:86},direction:"asc"},{field:{id:55},direction:"desc"}])

  describe "#addSortField updates rather than repeats fields when switching the sort direction", ->
    When  -> @BinderySearchService.addSortField(55,"desc")
    And  -> @BinderySearchService.addSortField(86,"asc")
    And  -> @BinderySearchService.addSortField(55,"asc")
    Then  -> expect(@BinderySearchService.sorting).toEqual([{field:{id:55},direction:"asc"},{field:{id:86},direction:"asc"}])
  
  describe "#removeSortField", ->
    When  -> @BinderySearchService.addSortField(55,"desc")
    And  -> @BinderySearchService.addSortField(86,"asc")
    And  -> @BinderySearchService.addSortField(108,"asc")
    And  -> @BinderySearchService.removeSortField(86)
    Then  -> expect(@BinderySearchService.sorting).toEqual([{field:{id:108},direction:"asc"},{field:{id:55},direction:"desc"}])

  describe "#toggleSortDirection toggles from current direction to the inverse", ->
    When  -> @BinderySearchService.addSortField(55,"desc")
    And  -> @BinderySearchService.toggleSortDirection({field:{id:55},direction:"desc"})
    Then  -> expect(@BinderySearchService.sorting[0].direction).toEqual("asc")

  describe "#parseFacets", ->
    When  -> @BinderySearchService.searchResponse = @sampleResponseWithFacets
    And  -> @BinderySearchService.parseFacets()
    Then  -> expect(@BinderySearchService.facets.model_name).toEqual([ {value:'url', count:10763}])
    Then  -> expect(@BinderySearchService.facets).toEqual({"model_name":[{value:"url",count:10763}],"date_ssi":[{value:"2014-08-28",count:4019},{value:"2014-08-23",count:2639},{value:"2014-08-27",count:1961},{value:"2014-08-30",count:1218},{value:"2014-09-01",count:257},{value:"2014-08-29",count:225},{value:"2014-08-24",count:190},{value:"2014-08-26",count:177},{value:"2014-08-25",count:77}],posted_time_dtsi:[{value:"2014-08-28T19:52:05Z",count:6},{value:"2014-08-23T10:22:34Z",count:5},{value:"2014-08-23T05:00:19Z",count:4},{value:"2014-08-23T09:30:08Z",count:4},{value:"2014-08-23T09:44:07Z",count:4},{value:"2014-08-23T18:00:11Z",count:4},{value:"2014-08-24T23:51:34Z",count:4},{value:"2014-08-27T08:56:09Z",count:4},{value:"2014-08-27T23:11:07Z",count:4},{value:"2014-08-28T00:15:17Z",count:4},{value:"2014-08-28T03:54:06Z",count:4}],source_urls_tesim:[{value:"http",count:10762},{value:"t.co",count:10762},{value:"smm918wo8",count:7},{value:"jk2iflfi3p",count:6},{value:"65dsvpayaf",count:5},{value:"7rrp7giuei",count:5},{value:"0fhyq0r8ft",count:4},{value:"12szwostnt",count:4},{value:"2ln70eckhm",count:4},{value:"2nvlctatuz",count:4},{value:"6bgvw9nqnn",count:4}],"text_tesim":[{value:"http",count:10745},{value:"t.co",count:10694},{value:"rt",count:5902},{value:"javascript",count:4147},{value:"html5",count:3162},{value:"jqueri",count:1573},{value:"css3",count:1278},{value:"develop",count:1236},{value:"angularj",count:991},{value:"us",count:979},{value:"via",count:950}],total_tweets_isi:[{value:"1",count:4330},{value:"3",count:2142},{value:"6",count:1177},{value:"2",count:651},{value:"10",count:442},{value:"4",count:239},{value:"9",count:185},{value:"5",count:155},{value:"15",count:154},{value:"7",count:150},{value:"12",count:120}],url_ssi:[{value:"http://antjanus.com/blog/web-development-tutorials/front-end-development/comprehensive-beginner-guide-angularjs",count:8},{value:"http://42yo.com",count:7},{value:"http://antjanus.com:80/blog/web-development-tutorials/front-end-development/comprehensive-beginner-guide-angularjs/?",count:7},{value:"http://appdevelopermagazine.com/1700/2014/7/25/monaca-updates-its-mobile-app-html5-ui-framework-now-with-jquery-support",count:7},{value:"http://ay.gy:80/rahy6?",count:7},{value:"http://bjorn.tipling.com/advanced-objects-in-javascript",count:7},{value:"http://blog.andyet.com/2014/08/13/opinionated-rundown-of-js-frameworks",count:7},{value:"http://cashclamber.com",count:7},{value:"http://ariya.ofilabs.com/2014/08/phantomjs-2-and-javascript-goodies.html",count:6},{value:"http://avocode.com",count:6},{value:"http://bjorn.tipling.com:80/advanced-objects-in-javascript?",count:6}]})
    Then  -> expect(@BinderySearchService.facets["toast_ssi"]).toBe(undefined)
  
  describe "#parseFacets ensures that all current constraints have an entry in @facets", ->
    When  -> @BinderySearchService.addFacetFilter("toast_ssi", "Ada Lovelace") 
    And  -> @BinderySearchService.parseFacets()
    Then  -> expect(@BinderySearchService.facets["toast_ssi"]).toEqual([{value:"Ada Lovelace"}])

  describe "#facetValuesFor", ->
    When  -> @BinderySearchService.searchResponse = @sampleResponseWithFacets
    And  -> @BinderySearchService.parseFacets()
    Then  -> expect(@BinderySearchService.facetValuesFor("model_name")).toEqual([{value:"url",count:10763}])
    Then  -> expect(@BinderySearchService.facetValuesFor("toast_ssi")).toEqual([])  
  
  describe "#facetValuesFor ensures that all current constraints have at least one corresponding facetValue", ->
    When  -> @BinderySearchService.addFacetFilter("toast_ssi", "Ada Lovelace") 
    Then  -> expect(@BinderySearchService.facetValuesFor("toast_ssi")).toEqual([{value:"Ada Lovelace"}]) 
    
  describe "#addFacetFilter", ->
    When  -> @BinderySearchService.addFacetFilter("date_created_dtsi", "2014-08-28T19:52:05Z") 
    Then  -> expect(@BinderySearchService.facetConstraints).toEqual([{fieldName:"date_created_dtsi", value:"2014-08-28T19:52:05Z"}]) 
    Then  -> expect(@BinderySearchService.queryParams()["f[date_created_dtsi][]"]).toEqual("2014-08-28T19:52:05Z")
    Then  -> expect(@BinderySearchService.runQuery).toHaveBeenCalled
  
  describe "#removeFacetFilter", ->
    When  -> @BinderySearchService.addFacetFilter("date_created_dtsi", "2014-08-28T19:52:05Z") 
    And   -> @BinderySearchService.removeFacetFilter("date_created_dtsi", "2014-08-28T19:52:05Z") 
    Then  -> expect(@BinderySearchService.isConstrainingBy("date_created_dtsi","2014-08-28T19:52:05Z")).toBe(false)
    Then  -> expect(@BinderySearchService.runQuery).toHaveBeenCalled
    
  describe "#isConstrainingBy", ->
    When  -> @BinderySearchService.facetConstraints = [{fieldName:"date_created_dtsi", value:"2014-08-28T19:52:05Z"}]
    Then  -> expect(@BinderySearchService.isConstrainingBy("date_created_dtsi")).toBe(true)
    Then  -> expect(@BinderySearchService.isConstrainingBy("date_created_dtsi","2014-08-28T19:52:05Z")).toBe(true)
    Then  -> expect(@BinderySearchService.isConstrainingBy("date_created_dtsi","differentvalue")).toBe(false)
    Then  -> expect(@BinderySearchService.isConstrainingBy("title_tesm")).toBe(false)
    Then  -> expect(@BinderySearchService.isConstrainingBy("title_tesm","My title")).toBe(false)
    