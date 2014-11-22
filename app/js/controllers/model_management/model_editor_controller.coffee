ModelEditorCtrl = ($scope, $stateParams, BinderyModel, context, memoService) ->
  # Models
  $scope.model = memoService.lookup('BinderyModel', $stateParams.modelId)
  if typeof($scope.model) == 'undefined'
    $scope.model = BinderyModel.get(modelId:$stateParams.modelId )

  $scope.typeOptionsFor = (fieldType) ->  return BinderyModel.typeOptionsFor(fieldType)
  $scope.pool = context.pool

  # Tabs
  $scope.tabs = [{label:"Fields & Associations", id:"schema"}, {label:"Edit Form", id:"form"}, {label:"Search Result", id:"search_result"}, {label:"Detail View", id:"detail_view"}]
  $scope.selectedTab = $scope.tabs[0]
  $scope.selectTab = (tab) -> $scope.selectedTab = tab
    
ModelEditorCtrl.$inject = ['$scope', '$stateParams', 'BinderyModel', 'ContextService', 'MemoService']
angular.module("app").controller('ModelEditorCtrl', ModelEditorCtrl)