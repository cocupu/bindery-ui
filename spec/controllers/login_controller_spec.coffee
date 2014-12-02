describe "controller: LoginController ($httpBackend.expect().respond, vanilla jasmine, coffeescript)", ->

  beforeEach -> module("app")

  beforeEach inject ($controller, $rootScope, $state, BinderyServer, Auth, @$httpBackend) ->
    @scope    = $rootScope.$new()
    @redirect = spyOn($state, 'go')
    $controller('LoginController', {$scope: @scope, $state, Auth})

  afterEach ->
    @$httpBackend.verifyNoOutstandingRequest()
    @$httpBackend.verifyNoOutstandingExpectation()

  describe "successfully logging in", ->
    it "should redirect you to /home", ->
      @$httpBackend.expectPOST('/users/sign_in.json', {user:@scope.credentials}).respond(200, {email:"current_user_email@test.com"})
      @$httpBackend.expectGET('/identities.json?email=current_user_email@test.com').respond([{"id":3,"name":"Nina Simone","created_at":"2013-08-01T22:05:37.766Z","updated_at":"2013-08-01T22:05:37.766Z","short_name":"ninasimone","url":"/ninasimone"}])
      @scope.login()
      @$httpBackend.flush()
      expect(@redirect).toHaveBeenCalledWith('identity.pools', {identityName:"ninasimone"})