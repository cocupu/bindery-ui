angular.module('curateDeps').factory('BinderyPool', ['$resource', 'BinderyAudienceCategory', 'BinderyModel', 'BinderyServer', ($resource, BinderyAudienceCategory, BinderyModel, bindery) ->

  BinderyPool = $resource(bindery.baseUrl+"/:identityName/:poolName.json", {identityName:'@identity', poolName:'@short_name'}, {
    update: { method: 'PUT' }
    query: {
        method: 'GET'
        url: '/:identityName.json'
        params: {identityName:'@identity'}
        isArray: true
        transformResponse: (data, header) ->
          wrapped = angular.fromJson(data);
          angular.forEach(wrapped, (item, idx) ->
            
              p = new BinderyPool(item)  #<-- replace each item with an instance of the resource object
              p.identity
              wrapped[idx] = p
              # memoService.createOrUpdate("BinderyPool", p)
          )
          return wrapped;
    }
    overview: {
      method: 'GET'
      url: '/:identityName/:poolName/overview.json'
      params: {identityName:'@identity', poolName:'@short_name'}
    }
  })

  BinderyPool.prototype.facets = () ->
    this.ensureCacheInitialized("facets")
    # always load with load_overview()
    return this.cache.facets
    
  BinderyPool.prototype.fields = () ->
    this.ensureCacheInitialized("fields")
    if (this.cache.fields.length == 0) && this.identity
      cache = this.cache
      cache.fields = $.ajax(this.identity+"/"+this.short_name+"/fields"+".json", {
            type: "get", contentType: "application/json"
            success: (result) -> cache.fields = result
        })
    return this.cache.fields

  BinderyPool.prototype.load_overview = () ->
    this.ensureCacheInitialized("overview")
    this.ensureCacheInitialized("facets")
    this.ensureCacheInitialized("models")
    this.ensureCacheInitialized("perspectives")
    if (this.cache.overview.length == 0) 
      cache = this.cache
      cache.overview = BinderyPool.overview( {identityName:this.identity, poolName:this.short_name}, (result) -> 
        cache.overview = result 
        cache.facets = result.facets
        cache.models = result.models
        cache.perspectives = result.perspectives
      )
    return this.cache.overview
        
  BinderyPool.prototype.models = () ->
    this.ensureCacheInitialized("models", [])
    if this.cache.models.length == 0 
      cache = this.cache
      this.cache.models = BinderyModel.query({identityName:this.identity, poolName:this.short_name}, (data) ->
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