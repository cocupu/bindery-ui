HomeController = ($scope, $state, context, Auth) ->

  $scope.context = context
  $scope.isAuthenticated = () ->  Auth.isAuthenticated()


HomeController.$inject = ['$scope', '$state', 'ContextService', 'Auth']
angular.module("app").controller('HomeController', HomeController)