angular.module('curateDeps').factory('BinderyNodeAssociations', ['$resource', '$location', 'BinderyModel', 'MemoService', 'BinderyServer', ($resource, $location, BinderyModel, memoService, bindery) ->

  BinderyNodeAssociation = $resource(bindery.baseUrl+"/nodes/:nodeId/associations.json", {}, {
    update: { method: 'PUT' }
  })

  return  BinderyNodeAssociation
])