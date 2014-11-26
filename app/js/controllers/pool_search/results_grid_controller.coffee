ResultsGridCtrl = ($scope, $stateParams, $http, $location, BinderyModel, BinderyNode, memoService, context, SearchService) ->
  $scope.setCurrentModel = (model) ->
    $scope.currentModel = model
    SearchService.model_id = model.id
    $scope.runQuery()
    $scope.columnDefs = model.columnDefsFromModel()

  #
  # ng-grid Configs
  #
  $scope.columnDefs = []
  $scope.columnDefsFromModel = () -> $scope.currentModel.columnDefsFromModel()

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
    useExternalSorting: true,
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


  $scope.$on('ngGridEventSorted', (event, data) ->
    SearchService.addSortField($scope.fieldIdFromGridColumn(data.fields[0]), data.directions[0])
  )

  $scope.$watch('searchService.sorting',  () ->
    $scope.runQuery()
  , true)

  $scope.fieldIdFromGridColumn = (gridField) ->
    regex = new RegExp(/data\[\'([0-9]*)\'\]/)
    return regex.exec(gridField)[1]


  # Ensuring the grid height is set correctly based on window size.
  # TODO: This is DOM Manipulation.  It should be implemented in a directive.
  #
  $scope.resizeGrid = () ->
    staticElementsHeight =   10+ $(".headsup").height() + $(".navbar-fixed-top").height() + $(".layout-chooser").height() + $(".navbar-fixed-bottom").height()
    newHeight = $(window).height() -  staticElementsHeight
    if $scope.sidebarVisible
      newWidth = $(window).width() - 286
    else
      newWidth = $(window).width()

    $(".ngGrid").height(newHeight)
    $(".ngGrid").width(newWidth)

  # Trigger on load and  when page resizes
  $( document ).ready( () -> $scope.resizeGrid() )
  $( window ).resize( () ->
    $scope.resizeGrid()
  )
  $scope.$watch('headsupVisible',  () ->
    $(window).trigger('resize');
  , true)
  $scope.$watch('sidebarVisible',  (newValue, oldValue) ->
    $(window).trigger('resize');
  , true)

ResultsGridCtrl.$inject = ['$scope', '$stateParams', '$http', '$location', 'BinderyModel', 'BinderyNode', 'MemoService', 'ContextService', 'BinderySearchService']
angular.module("curateDeps").controller('ResultsGridCtrl', ResultsGridCtrl)