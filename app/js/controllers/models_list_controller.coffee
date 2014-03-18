ModelsListCtrl = ($scope, $stateParams, $location, BinderyModel, context) ->
  context.initialize($stateParams.identityName, $stateParams.poolName)
  # TODO: This should rely on context.pool to retrieve & cache the BinderyModels
  $scope.models = BinderyModel.query({identityName:$stateParams.identityName, poolName:$stateParams.poolName})
  
ModelsListCtrl.$inject = ['$scope', '$stateParams', '$location', 'BinderyModel', 'ContextService']
angular.module("app").controller('ModelsListCtrl', ModelsListCtrl)