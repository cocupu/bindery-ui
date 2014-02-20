angular.module('curateDeps').factory('BinderySpreadsheet', ['$resource', '$location', 'BinderyModel', 'memoService', ($resource, $location, BinderyModel, memoService) ->

  BinderySpreadsheet = $resource(":identityId/:poolId/spreadsheets/:nodeId.json", {nodeId:'@id'}, {
    update: { method: 'PUT' }
  })

  return  BinderySpreadsheet
])