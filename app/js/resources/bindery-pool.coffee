angular.module('curateDeps').factory('BinderyPool', ['$resource', 'BinderyAudienceCategory', 'BinderyModel', ($resource, BinderyAudienceCategory, BinderyModel) ->

  BinderyPool = $resource("/:identityName/:poolName.json", {identityName:'@identity_name', poolName:'@short_name'}, {
    update: { method: 'PUT' }
  })

  BinderyPool.prototype.fields = () ->
    this.ensureCacheInitialized("fields")
    if (this.cache.fields.length == 0) && this.identity_name
      cache = this.cache
      cache.fields = $.ajax(this.identity_name+"/"+this.short_name+"/fields"+".json", {
            type: "get", contentType: "application/json"
            success: (result) -> cache.fields = result
        })
    return this.cache.fields

      
  BinderyPool.prototype.models = () ->
    this.ensureCacheInitialized("models", [])
    if this.cache.models.length == 0
      cache = this.cache
      this.cache.models = BinderyModel.query({identityName:this.identity_name, poolName:this.short_name}, (data) ->
        cache.models = data
      )
    return this.cache.models
            
  BinderyPool.prototype.loadAudienceCategories = () ->
    this.audience_categories = []
    audience_categories = this.audience_categories
    BinderyAudienceCategory.query({poolName: this.short_name, identityName:this.identityName}, (data) ->
      audience_categories.concat(data)
    )

  BinderyPool.prototype.addContributor = () ->
    this.access_controls.push {identity:"", access:"EDIT"}

  BinderyPool.prototype.removeContributor = (contributor) ->
    index = this.access_controls.indexOf(contributor);
    this.access_controls.splice(index, 1);

  BinderyPool.prototype.ensureCacheInitialized = (key, initvalue=[]) ->
    if (typeof(this.cache) == "undefined")
      this.cache = {}
    if typeof(this.cache[key]) == "undefined"
      this.cache[key] = initvalue
        
  return  BinderyPool
])