# Editable Grid
SpawnJobEditorCtrl = ($scope, $routeParams, $http, context, BinderySpreadsheet, BinderyMappingTemplate) ->

  # General Scope properties
  context.initialize($routeParams.identityName, $routeParams.poolName)
  $scope.context = context
  $scope.pool = context.pool
  $scope.spreadsheet = BinderySpreadsheet.get({identityId:$routeParams.identityName, poolId:$routeParams.poolName, nodeId:$routeParams.source_node_id},(spreadsheet) ->
    $scope.sampleRows = spreadsheet.rows.slice(1,10)
    $scope.headerRow = [spreadsheet.rows[0]]
    $scope.headerGridColumnDefs = $.map( $scope.headerRow[0], ( val, i ) -> {displayName:val, field: ''} )
    $scope.mappingTemplate.model_mappings[0].field_mappings = $.map( $scope.headerRow[0], ( val, i ) -> {source:i, label: val} )
    $scope.mappingTemplate.model_mappings[0].name = spreadsheet.title + " Row"
  )
  $scope.mappingTemplate = new BinderyMappingTemplate({
    row_start: 2
    model_mappings: [{name: "", label:""}]
  });

  $scope.createMappingTemplate = (mappingTemplate) ->
    mappingTemplate.$save({identityId:$routeParams.identityName, poolId:$routeParams.poolName}, (returnedTemplate) ->
      $scope.mappingTemplate = returnedTemplate
      console.log($scope.mappingTemplate)
    )

  $scope.updateMappingTemplate = (mappingTemplate) ->
    $scope.mappingTemplate = mappingTemplate.$update({identityId:$routeParams.identityName, poolId:$routeParams.poolName}, (returnedTemplate) ->
      $scope.mappingTemplate = returnedTemplate
      console.log($scope.mappingTemplate)
    )
  $scope.spawn = (mappingTemplate, spreadsheet) ->
    data = {
      source_node_id: spreadsheet.node_version_id
      mapping_template_id: mappingTemplate.id
    }
    $http.post(context.poolUrl+'/spawn_jobs', data).success(
      window.location.replace(context.poolUrl);
    )

  $scope.headerRow = []
  $scope.sampleRows = []
  $scope.headerGridColumnDefs = []

  $scope.headerGridOptions = {
    data: "headerRow"
    columnDefs: "headerGridColumnDefs"
  }
  $scope.gridOptions = {
    data: "sampleRows"
    showFooter: false
    footerRowHeight: 0
  }


SpawnJobEditorCtrl.$inject = ['$scope', '$routeParams', '$http', 'contextService', 'BinderySpreadsheet', 'BinderyMappingTemplate']
angular.module("curateDeps").controller('SpawnJobEditorCtrl', SpawnJobEditorCtrl)