# Editable Grid with Headsup
PoolSearchCtrl = ($scope, $stateParams, $http, $location, BinderyModel, BinderyNode, memoService, context, SearchService) ->
    
  # General Scope properties
  $scope.controller = "search"
  context.initialize($stateParams.identityName, $stateParams.poolName)
  $scope.stateParams = $stateParams

  $scope.poolUrl = context
  $scope.searchService = SearchService
  $scope.queryParams = () -> SearchService.queryParams()
  $scope.searchResponse = SearchService.searchResponse
  $scope.docs = SearchService.docs
  $scope.totalServerItems = SearchService.totalServerItems

  $scope.searchUrl = $location.path()+".json"
  $scope.detailPanelState = "node"
  $scope.infoPanelState = "default"
  $scope.supplementalPanelState = "none"
  $scope.supplementalNode = {}
  $scope.focusedField = {}

  $scope.filterOptions =
    filterText: SearchService.queryString,
    useExternalFilter: true

  $scope.totalServerItems = 0
  $scope.pagingOptions =
    pageSizes: [25, 50, 100, 250, 500, 1000],
    pageSize: 25,
    currentPage: 1

  $scope.runQuery = () ->
    SearchService.pagingOptions.pageSize = $scope.pagingOptions.pageSize
    SearchService.pagingOptions.currentPage = $scope.pagingOptions.currentPage
    #    SearchService.queryString = $scope.filterOptions.filterText
    SearchService.runQuery().then( (data) ->
      $scope.docs = SearchService.docs
      $scope.searchResponse = SearchService.searchResponse
      $scope.totalServerItems = SearchService.totalServerItems
      if (!$scope.$$phase)
        $scope.$apply()
    )

  $scope.runQuery()

  $scope.$watch('pagingOptions', ((newVal, oldVal) ->
    if (newVal != oldVal && newVal.currentPage != oldVal.currentPage)
      $scope.runQuery()
  ), true)

  $scope.$watch('filterOptions', ((newVal, oldVal) ->
    if (newVal != oldVal)
      $scope.runQuery()
  ), true);

  $scope.$watch('searchService.queryString', ((newVal, oldVal) ->
    if (newVal != oldVal)
      $scope.runQuery()
  ), true);

  
  #
  # Sidebar & Headsup
  #
  $scope.sidebarVisible = true
  $scope.toggleSidebar = (variable) -> $scope.sidebarVisible = !$scope.sidebarVisible
  $scope.headsupVisible = true
  $scope.toggleHeadsup = (variable) -> $scope.headsupVisible = !$scope.headsupVisible
  $scope.resultsLayout = 'grid'
  $scope.setResultsLayout = (layout) -> $scope.resultsLayout = layout

  #
  # Logic for Manipulating Models and Nodes
  #
  $scope.selectedNodes = []
  $scope.currentNode = {}
  $scope.currentModel = {}
  if SearchService.model_id
    BinderyModel.get({modelId:SearchService.model_id}, (m, getResponseHeaders) ->
      memoService.createOrUpdate("BinderyModel", m)
      $scope.setCurrentModel(m)
    )


  $scope.modelChooserLabel = () ->
    if $scope.currentModel.name
      return $scope.currentModel.name
    else
      return "Choose Model"
      
  $scope.models = BinderyModel.query({identityName:$stateParams.identityName, poolName:$stateParams.poolName})
    
  $scope.selectNode = (node) ->
    $scope.selectedNodes[0] = node
    $scope.currentNode = node

  $scope.typeOptionsFor = (fieldType) ->  return BinderyModel.typeOptionsFor(fieldType)

  $scope.modelFor = (node) ->
    BinderyModel.get({modelId: node.model_id})

  $scope.updateModel = (model) ->
    model.$update( (savedModel, putResponseHeaders) ->
      now = new Date()
      model.lastUpdated = now.getHours()+':'+now.getMinutes().leftZeroPad(2)+':'+now.getSeconds().leftZeroPad(2)
      model.dirty = false
    )

  #
  # STATE Manipulations
  # TODO: This is basically DOM manipulation right now. It should be implemented as state changes that then drive directives.
  #
  $scope.focusOnField = (fieldConfig) ->
    $scope.focusedField  = fieldConfig
    $scope.supplementalPanelState = "field"


  $scope.configField = (fieldConfig) ->
    $scope.focusedField  = fieldConfig
    $scope.supplementalPanelState = "model"
    window.setTimeout(() ->
      $("#modelField_"+fieldConfig.id+"_name").focus()
    ,100)

  $scope.openNodeSupplemental = (pid) ->
    $scope.supplementalNode = BinderyNode.get({nodeId:pid}, (node) ->
      $scope.supplementalPanelState = "node"
    )



PoolSearchCtrl.$inject = ['$scope', '$stateParams', '$http', '$location', 'BinderyModel', 'BinderyNode', 'MemoService', 'ContextService', 'BinderySearchService']
angular.module("curateDeps").controller('PoolSearchCtrl', PoolSearchCtrl)