angular.module('curateDeps').factory('BinderyAudienceCategory', ['$resource', 'BinderyAudience', ($resource, BinderyAudience) ->

  BinderyAudienceCategory = $resource("/:identityName/:poolName/audience_categories/:categoryId", {identityName:'@identity_name', poolName:'@pool_name', categoryId:'@id'}, {
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