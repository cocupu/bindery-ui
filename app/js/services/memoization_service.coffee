angular.module('curateDeps').factory('memoService', [ () ->
  memoService = { cache: {}}

  memoService.lookup = (model, objectId) ->
    this.ensureInitialized(model)
    return this.cache[model][objectId]

  # Add object to cache or update existing entry in the cache
  memoService.createOrUpdate = (model, stuffToStore) ->
    this.ensureInitialized(model)
    if Array.isArray(stuffToStore)
      angular.forEach(stuffToStore, (object, idx) ->
        this.cache[model][object.id] = object
      )
    else
      object = stuffToStore
      this.cache[model][object.id] = object
#      console.log model
#      console.log this.cache[model]
    return stuffToStore

  memoService.ensureInitialized = (model) ->
    if typeof(this.cache[model]) == "undefined"
      memoService.cache[model] = {}

  return memoService
])