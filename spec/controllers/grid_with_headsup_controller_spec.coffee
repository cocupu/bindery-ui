describe "controller: LoginController ($httpBackend.expect().respond, vanilla jasmine, coffeescript)", ->

  beforeEach -> module("app")

  beforeEach inject ($controller, $rootScope, @$location, AuthenticationService, @$httpBackend) ->


  afterEach ->


  describe "successfully logging in", ->

