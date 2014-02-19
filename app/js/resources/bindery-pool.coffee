angular.module('curateDeps').factory('BinderyPool', ['$resource', 'BinderyAudienceCategory', ($resource, BinderyAudienceCategory) ->

  BinderyPool = $resource("/:identityName/:poolName.json", {identityName:'@identity_name', poolName:'@short_name'}, {
    update: { method: 'PUT' }
  })

  BinderyPool.prototype.fields = () ->
    if (typeof(this.cache) == "undefined")
      this.cache = {}
    if (typeof(this.cache.fields) == "undefined") && this.identity_name
      cache = this.cache
      cache.fields = $.ajax(this.identity_name+"/"+this.short_name+"/fields"+".json", {
            type: "get", contentType: "application/json"
            success: (result) -> cache.fields = result
        })
    return this.cache.fields

  BinderyPool.prototype.loadAudienceCategories = () ->
    this.audience_categories = []
    audience_categories = this.audience_categories
    BinderyAudienceCategory.query({poolName: this.short_name, identityName:this.identityName}, (data)->
      console.log data
      audience_categories.concat(data)
    )

  BinderyPool.prototype.addContributor = () ->
    this.access_controls.push {identity:"", access:"EDIT"}

  BinderyPool.prototype.removeContributor = (contributor) ->
    index = this.access_controls.indexOf(contributor);
    this.access_controls.splice(index, 1);

  return  BinderyPool
])