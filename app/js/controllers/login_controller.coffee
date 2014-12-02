LoginController = ($scope, $state, context, Auth, BinderyIdentity) ->

  $scope.credentials = { email: "", password: "" }
  $scope.context = context

  onLoginSuccess = () ->
    $location.path('/home');

  $scope.login = () ->
    Auth.login($scope.credentials).then( (user) ->
      console.log()
    , (error) ->
      console.log("Login Failed");
      console.log($scope.credentials);
      # Authentication failed...
    )

  $scope.$on('devise:login', (event, currentUser) ->
    # after a login, a hard refresh, a new tab
    $scope.loginSuccess(currentUser)
  )

  $scope.$on('devise:new-session', (event, currentUser) ->
    # user logged in by Auth.login({...})
  )

  $scope.loginSuccess = (currentUser) ->
    BinderyIdentity.query(email:currentUser.email, (identities) ->
      $scope.context.initialize(identities[0].short_name)
      $state.go('identity.pools', {identityName:identities[0].short_name})
    )



LoginController.$inject = ['$scope', '$state', 'ContextService', 'Auth', 'BinderyIdentity']
angular.module("app").controller('LoginController', LoginController)