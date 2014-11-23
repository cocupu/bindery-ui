angular.module('curateDeps').factory('BinderyMappingTemplate', ['$resource', '$location', 'BinderyModel', 'memoService', 'BinderyServer', ($resource, $location, BinderyModel, memoService, bindery) ->

  BinderyMappingTemplate = $resource(bindery.baseUrl+"/:identityId/:poolId/mapping_templates/:templateId", {templateId:'@id'}, {
    update: { method: 'PUT' }
  })

  return  BinderyMappingTemplate
])