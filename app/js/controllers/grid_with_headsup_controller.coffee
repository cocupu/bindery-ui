# Editable Grid with Headsup
GridWithHeadsupCtrl = ($scope, $stateParams, $http, $location, BinderyModel, BinderyNode, memoService, context, SearchService) ->
    
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
    $scope.currentModel = BinderyModel.get({modelId:SearchService.model_id}, (m, getResponseHeaders) ->
      memoService.createOrUpdate("BinderyModel", m)
      $scope.columnDefs = m.columnDefsFromModel()
    )
  $scope.modelChooserLabel = () ->
    if $scope.currentModel.name
      return $scope.currentModel.name
    else
      return "Choose Model"
      
  $scope.models = BinderyModel.query({identityName:$stateParams.identityName, poolName:$stateParams.poolName})
  $scope.selectModel = (model) ->
    SearchService.model_id = model.id
    $scope.runQuery()
    $scope.currentModel = model
    
  $scope.selectNode = (node) -> $scope.selectedNodes[0] = node
  $scope.typeOptionsFor = (fieldType) ->  return BinderyModel.typeOptionsFor(fieldType)

  $scope.modelFor = (node) ->
    BinderyModel.get({modelId: node.model_id})

  $scope.updateModel = (model) ->
    model.$update( (savedModel, putResponseHeaders) ->
      now = new Date()
      model.lastUpdated = now.getHours()+':'+now.getMinutes().leftZeroPad(2)+':'+now.getSeconds().leftZeroPad(2)
      model.dirty = false
    )

  $scope.updateNode = (node) ->
    node.$update( (savedNode, putResponseHeaders) ->
      now = new Date()
      node.lastUpdated = now.getHours()+':'+now.getMinutes().leftZeroPad(2)+':'+now.getSeconds().leftZeroPad(2)
      node.dirty = false
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
      $("#modelField_"+fieldConfig.code+"_name").focus()
    ,100)

  $scope.openNodeSupplemental = (pid) ->
    $scope.supplementalNode = BinderyNode.get({nodeId:pid}, (node) ->
      $scope.supplementalPanelState = "node"
    )

  #
  # tokeninput config options
  #
  $scope.nodeTokeninputOptions = {
    propertyToSearch: "title"
    jsonContainer: "docs"
    preventDuplicates: true
    theme: "facebook"
    onResult:  (results) ->
      angular.forEach(results.docs, (item, idx) ->
        results.docs[idx] = new BinderyNode(item)  #<-- replace each item with an instance of the resource object
      )
      return results;
    resultsFormatter: (item) ->
      return "<li>"+item.title+"</li>"
    tokenFormatter: (item) ->
      switch item.file_type
        when "audio"
          fieldHtml = "<li class=\"selected-token file audio "+item.persistent_id+"\" ng-click=\"openNodeSupplemental('"+item.persistent_id+"')\" ng-focus=\"focusOnField(fieldConfig)\"><audio controls><source src=\""+item.download_url()+"\" type=\"audio/mpeg\"></source></audio><div class=\"token-info\">"+item.title+"<br/>"+item.data['content-type']+"</div></li>"
        when "video"
          fieldHtml = "<li class=\"selected-token file video "+item.persistent_id+"\" ng-click=\"openNodeSupplemental('"+item.persistent_id+"')\" ng-focus=\"focusOnField(fieldConfig)\"><video controls><source src=\""+item.download_url()+"\" type=\"video/mp4\"></source></video><div class=\"token-info\">"+item.title+"</div></li>"
        when "spreadsheet"
          fieldHtml = "<li class=\"selected-token file spreadsheet "+item.persistent_id+"\" ng-click=\"openNodeSupplemental('"+item.persistent_id+"')\" ng-focus=\"focusOnField(fieldConfig)\"><div class=\"token-info\">"+item.title+"</div></li>"
        when "generic"
          fieldHtml = "<li class=\"selected-token file generic "+item.persistent_id+"\" ng-click=\"openNodeSupplemental('"+item.persistent_id+"')\" ng-focus=\"focusOnField(fieldConfig)\"><div class=\"token-info\">"+item.title+"</div></li>"
        else
          fieldHtml = "<li class=\"selected-token "+item.persistent_id+"\" ng-click=\"openNodeSupplemental('"+item.persistent_id+"')\" ng-focus=\"focusOnField(fieldConfig)\">"+item.title+"</li>"

      return fieldHtml

    # initialize selections within the tokeninput element
    # @param scope of the directive
    # @param element the directive is attached to
    # @param callback to trigger for each JSON object that should be added to the array of selections
    initSelection: (scope, element, callback) ->
      ids = scope.$eval(element.attr("ng-model"))
      angular.forEach(ids, (pid) ->
        node = BinderyNode.get({nodeId:pid}, () ->
          node.id = node.persistent_id
          callback(node)
        )
      )
  }


  #
  # ng-grid Configs
  #
  $scope.columnDefs = []
  $scope.columnDefsFromModel = () -> $scope.currentModel.columnDefsFromModel()

  $scope.filterOptions =
    filterText: "",
    useExternalFilter: true

  $scope.totalServerItems = 0
  $scope.pagingOptions =
    pageSizes: [25, 50, 100, 250, 500, 1000],
    pageSize: 25,
    currentPage: 1
    
  $scope.runQuery = () ->
    SearchService.pagingOptions.pageSize = $scope.pagingOptions.pageSize
    SearchService.pagingOptions.currentPage = $scope.pagingOptions.currentPage
    SearchService.queryString = $scope.filterOptions.filterText
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


  setGridOptions = () ->

  $scope.gridOptions =
    data: 'docs'
    selectedItems: $scope.selectedNodes
    selectedIndex: $scope.selectedCellIndex
    multiSelect: false
    enableCellSelection: true
    enableCellEdit: false
    enableRowSelection: true
    columnDefs: 'columnDefs'
    rowHeight: "50"
    enablePaging: true,
    showFooter: true,
    footerRowHeight: "30",
    totalServerItems: 'totalServerItems',
    pagingOptions: $scope.pagingOptions,
    filterOptions: $scope.filterOptions,
    afterSelectionChange: (rowItem, event) ->
      if ($scope.currentNode == rowItem)
#        This is where we could focus on field control corresponding to selected cell
        selectedCell = $('.ngCellElement:focus')
        if (selectedCell.length > 0)
          selectedCol = selectedCell.attr('class').split(" ").filter( (x) -> return x.indexOf("colt") > -1 )[0]
          $(".fieldControl."+selectedCol).focus()
      else
        $scope.currentNode = rowItem


  # Ensuring the grid height is set correctly based on window size.
  # TODO: This is DOM Manipulation.  It should be implemented in a directive.
  #
  $scope.resizeGrid = () ->
    staticElementsHeight = $(".row").height() + $(".headsup").not(":hidden").height() + $(".navbar-fixed-top").height() + $(".navbar-fixed-bottom").height()
    newHeight = Math.max(100, $(window).height() - staticElementsHeight)
    $(".ngGrid").height(newHeight)

  # Trigger on load and  when page resizes
  $( document ).ready( () -> $scope.resizeGrid() )
  $( window ).resize( () ->
    $scope.resizeGrid()
  )

GridWithHeadsupCtrl.$inject = ['$scope', '$stateParams', '$http', '$location', 'BinderyModel', 'BinderyNode', 'MemoService', 'ContextService', 'BinderySearchService']
angular.module("curateDeps").controller('GridWithHeadsupCtrl', GridWithHeadsupCtrl)