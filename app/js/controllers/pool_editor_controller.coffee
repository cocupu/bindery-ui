# Editable Grid
PoolEditorCtrl = ($scope, $routeParams, BinderyPool, BinderyIdentity, context) ->

  # General Scope properties
  context.initialize($routeParams.identityName, $routeParams.poolName)
  $scope.context = context
  $scope.pool = context.pool

  $scope.navigationOptions =
    [
      { id: "pool_info", name: "Pool Info"  },
      { id: "contributors", name: "Contributors" },
      { id: "audiences", name: "Audiences" },
      { id: "sources", name: "Sources" }
      { id: "indexing", name: "Indexing" }
    ]
  $scope.currentNav = $scope.navigationOptions[0]
  $scope.updatePool = (pool) ->
    pool.$update( (savedPool, putResponseHeaders) ->
      now = new Date()
      pool.lastUpdated = now.getHours()+':'+now.getMinutes().leftZeroPad(2)+':'+now.getSeconds().leftZeroPad(2)
      pool.dirty = false
    )

  $scope.addContributor = () -> $scope.pool.addContributor()
  $scope.removeContributor = (contributor) ->  $scope.pool.removeContributor(contributor)

  $scope.selectNavOption = (selection) -> $scope.currentNav = selection

  #
  # tokeninput config options
  #
  $scope.contributorTokeninputOptions = {
    propertyToSearch: "short_name"
    tokenValue: "short_name"
    tokenLimit: 1
    theme: "facebook"
    resultsFormatter: (item) ->
      if item.name
        name = item.name+" ("+item.short_name+")"
      else
        name = item.short_name
      return "<li>"+name+"</li>"

    tokenFormatter: (item) ->
      if item.name
        name = item.name+" ("+item.short_name+")"
      else
        name = item.short_name
      fieldHtml = "<li class=\"selected-token "+item.id+"\" ng-click=\"openNodeSupplemental('"+item.id+"')\" ng-focus=\"focusOnField(fieldConfig)\">"+name+"</li>"
      return fieldHtml
    # initialize selections within the tokeninput element
    # @param scope of the directive
    # @param element the directive is attached to
    # @param callback to trigger for each JSON object that should be added to the array of selections
    initSelection: (scope, element, callback) ->
      name = scope.$eval(element.attr("ng-model"))
      if name.length > 0
        identity = BinderyIdentity.get({name:name}, () ->
          callback(identity)
        )

  }

PoolEditorCtrl.$inject = ['$scope', '$routeParams', 'BinderyPool', 'BinderyIdentity', 'contextService']
angular.module("curateDeps").controller('PoolEditorCtrl', PoolEditorCtrl)