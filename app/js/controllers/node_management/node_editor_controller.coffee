NodeEditorCtrl = ($scope, $stateParams, $http, $location, BinderyModel, BinderyNode, memoService, context, SearchService) ->

  $scope.model = $scope.node.model()

  $scope.updateNode = (node) ->
    node.$update( (savedNode, putResponseHeaders) ->
      now = new Date()
      node.lastUpdated = now.getHours()+':'+now.getMinutes().leftZeroPad(2)+':'+now.getSeconds().leftZeroPad(2)
      node.dirty = false
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

NodeEditorCtrl.$inject = ['$scope', '$stateParams', '$http', '$location', 'BinderyModel', 'BinderyNode', 'MemoService', 'ContextService', 'BinderySearchService']
angular.module("curateDeps").controller('NodeEditorCtrl', NodeEditorCtrl)