angular.module('curateDeps').factory('BinderyMappingTemplate', ['$resource', '$location', 'BinderyModel', 'memoService', ($resource, $location, BinderyModel, memoService) ->

  BinderyMappingTemplate = $resource(":identityId/:poolId/mapping_templates/:templateId", {templateId:'@id'}, {
    update: { method: 'PUT' }
  })

  return  BinderyMappingTemplate
])