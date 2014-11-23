angular.module('curateDeps').factory('BinderySpreadsheet', ['$resource', '$location', 'BinderyModel', 'memoService', 'BinderyServer', ($resource, $location, BinderyModel, memoService, bindery) ->

  BinderySpreadsheet = $resource(bindery.baseUrl+"/:identityId/:poolId/spreadsheets/:nodeId.json", {nodeId:'@id'}, {
    update: { method: 'PUT' }
  })

  return  BinderySpreadsheet
])