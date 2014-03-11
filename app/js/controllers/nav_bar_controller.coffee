NavBarCtrl = ($scope, $stateParams, context) ->
  $scope.context = context

NavBarCtrl.$inject = ['$scope', '$stateParams', 'ContextService']
angular.module("app").controller('NavBarCtrl', NavBarCtrl)