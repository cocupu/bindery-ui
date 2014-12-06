ModelEditorCtrl = ($scope, $stateParams, $state, BinderyModel, context, memoService) ->
  # Models
  $scope.model = memoService.lookup('BinderyModel', $stateParams.modelId)
  if typeof($scope.model) == 'undefined'
    $scope.model = BinderyModel.get(modelId:$stateParams.modelId )

  $scope.typeOptionsFor = (fieldType) ->  return BinderyModel.typeOptionsFor(fieldType)
  $scope.pool = context.pool

  # Tabs
  $scope.tabs = [{label:"Fields & Associations", id:"schema"}, {label:"Edit Form", id:"form"}, {label:"Search Result", id:"search_result"}, {label:"Detail View", id:"detail_view"}, {label:"Delete model", id:"delete_view"}]
  $scope.selectedTab = $scope.tabs[0]
  $scope.selectTab = (tab) -> $scope.selectedTab = tab
  
  # Actions
  $scope.deleteModel = (model) ->
    model.$delete(
      console.log("deleting")
      console.log(model)
      $state.go('curate.pool.models.edit')
    )
    
ModelEditorCtrl.$inject = ['$scope', '$stateParams', '$state', 'BinderyModel', 'ContextService', 'MemoService']
angular.module("app").controller('ModelEditorCtrl', ModelEditorCtrl)