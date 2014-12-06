ModelsListCtrl = ($scope, $stateParams, $state, $location, BinderyModel, context) ->
  context.initialize($stateParams.identityName, $stateParams.poolName)
  # TODO: This should rely on context.pool to retrieve & cache the BinderyModels
  $scope.models = BinderyModel.query({identityName:$stateParams.identityName, poolName:$stateParams.poolName})
  $scope.newModel = () ->
    newModel = new BinderyModel(identityName:$stateParams.identityName, poolName:$stateParams.poolName, model:{name:'New Model'})
    newModel.$create( (createdModel, postResponseHeaders) -> 
      $scope.models << createdModel
      $state.go('curate.pool.models.edit', {modelId:createdModel.id})
    )
      
  
ModelsListCtrl.$inject = ['$scope', '$stateParams', '$state', '$location', 'BinderyModel', 'ContextService']
angular.module("app").controller('ModelsListCtrl', ModelsListCtrl)