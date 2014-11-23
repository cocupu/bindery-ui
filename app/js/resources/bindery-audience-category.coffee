angular.module('curateDeps').factory('BinderyAudienceCategory', ['$resource', 'BinderyAudience','BinderyServer', ($resource, BinderyAudience, bindery) ->

  BinderyAudienceCategory = $resource(bindery.baseUrl+"/:identityName/:poolName/audience_categories/:categoryId", {identityName:'@identity_name', poolName:'@pool_name', categoryId:'@id'}, {
    update: { method: 'PUT' }
  })

  BinderyAudienceCategory.prototype.reifyAudiences = () ->
    audiences = this.audiences
    angular.forEach(this.audiences, (item, idx) ->
      audiences[idx] = new BinderyAudience(item)
    )
    return audiences

  return  BinderyAudienceCategory
])