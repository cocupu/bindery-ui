describe "model: BinderyIdentity", ->

  beforeEach -> module("curateDeps")

  beforeEach inject ($controller, $rootScope, @$location, @BinderyIdentity, @$httpBackend) ->
    @scope    = $rootScope.$new()
    @redirect = spyOn($location, 'path')
  # $factory('BinderyModel', {$scope: @scope, $location, AuthenticationService})

  afterEach ->
    @$httpBackend.verifyNoOutstandingRequest()
    @$httpBackend.verifyNoOutstandingExpectation()

  describe "query", ->
    it "should query identities in DataBindery", ->
      sampleResponse = [{"id":3,"name":"Nina Simone","created_at":"2013-08-01T22:05:37.766Z","updated_at":"2013-08-01T22:05:37.766Z","short_name":"ninasimone","url":"/ninasimone"}, {"id":3,"name":"Simone de Beauvoir","created_at":"2013-08-01T22:05:37.766Z","updated_at":"2013-08-01T22:05:37.766Z","short_name":"simone_debauvoir","url":"/simone_debauvoir"}]
      @$httpBackend.expectGET('/identities.json?q=simone').respond(sampleResponse)
      result = @BinderyIdentity.query(q:"simone")
      @$httpBackend.flush()
      expect(result.length).toBe(2)
    it "should allow querying for current user's identities", ->
      sampleResponse = [[{"id":4,"name":null,"created_at":"2013-08-12T15:53:25.109Z","updated_at":"2013-08-12T15:53:25.109Z","short_name":"archivist1","url":"/archivist1"}]]
      @$httpBackend.expectGET('/identities.json?q=current_user').respond(sampleResponse)
      result = @BinderyIdentity.query(q:"current_user")
      @$httpBackend.flush()
      expect(result.length).toBe(1)