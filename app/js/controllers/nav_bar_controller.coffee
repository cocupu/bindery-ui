NavBarCtrl = ($scope, $stateParams, context, Auth) ->
  $scope.context = context
  $scope.stateParams = $stateParams

  $scope.logout = () ->
    Auth.logout().then( (oldUser) ->
      console.log(oldUser)
    , (error) ->
      # An error occurred logging out.
    )

  $scope.$on('devise:logout', (event, oldCurrentUser) -> console.log("Logout complete.") )


NavBarCtrl.$inject = ['$scope', '$stateParams', 'ContextService', 'Auth']
angular.module("app").controller('NavBarCtrl', NavBarCtrl)