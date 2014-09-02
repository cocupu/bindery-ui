NavBarCtrl = ($scope, $stateParams, context) ->
  $scope.context = context
  $scope.stateParams = $stateParams

NavBarCtrl.$inject = ['$scope', '$stateParams', 'ContextService']
angular.module("app").controller('NavBarCtrl', NavBarCtrl)