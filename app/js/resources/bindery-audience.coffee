angular.module('curateDeps').factory('BinderyAudience', ['$resource', ($resource) ->

  BinderyAudience = $resource("/:identityName/:poolName/audience_categories/:categoryId/audiences/:id", {identityName:'@identity_name', poolName:'@pool_name', categoryId:'@audience_category_id', id:'@id'}, {
    save: {
      method: 'POST',
      isArray: false, # <- not returning an array
      transformResponse: (data, header) ->
        console.log(header)
        return data
    }
    update: { method: 'PUT' }
  })
  BinderyAudience.prototype.addFilter = () ->
    newFilter = {field_name:"", values:[], operator:"+"}
    this.filters.push(newFilter)

  BinderyAudience.prototype.removeFilter = (filter) ->
    index = this.filters.indexOf(filter);
    this.filters.splice(index, 1);

  return  BinderyAudience
])