angular.module('curateDeps').factory('BinderyNodeAssociations', ['$resource', '$location', 'BinderyModel', 'MemoService', ($resource, $location, BinderyModel, memoService) ->

  BinderyNodeAssociation = $resource("nodes/:nodeId/associations.json", {}, {
    update: { method: 'PUT' }
  })

  return  BinderyNodeAssociation
])