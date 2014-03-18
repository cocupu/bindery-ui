describe "model: BinderyModel", ->

  beforeEach -> module("curateDeps")

  beforeEach inject ($controller, $rootScope, @$location, @BinderyModel, @$httpBackend) ->
    @scope    = $rootScope.$new()
    @redirect = spyOn($location, 'path')
    # $factory('BinderyModel', {$scope: @scope, $location, AuthenticationService})

  afterEach ->
    @$httpBackend.verifyNoOutstandingRequest()
    @$httpBackend.verifyNoOutstandingExpectation()

  describe "query", ->
    it "should query the pool models", ->
      sampleResponse = [{"id":5,"url":"/models/5","associations":[],"fields":[{"name":"Tibetan Material","type":"text","uri":"","code":"tibetan_material"},{"name":"Tibetan Content","type":"textarea","uri":"","code":"tibetan_content"}]}, {"id":2,"url":"/models/2","associations":[],"fields":[{"code":"submitted_by","name":"Submitted By"},{"code":"collection_name_","name":"Collection Name"},{"code":"media","name":"Media"},{"code":"#_of_media","name":"# of Media"}]}]
      @$httpBackend.expectGET('/fakeId/fakePool/models.json?').respond(sampleResponse)
      result = @BinderyModel.query(identityName:"fakeId", poolName:"fakePool")
      @$httpBackend.flush()
      expect(result.length).toBe(2)
