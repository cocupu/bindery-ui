class MemoService extends AngularService
  @register angular.module('curateDeps')
  @cache = {}
  
  initialize: ->
    @cache = {}
  
  lookup: (model, objectId) ->
    @ensureInitialized(model)
    return @cache[model][objectId]
  
  # Add object to cache or update existing entry in the cache
  createOrUpdate: (model, stuffToStore) ->
    @ensureInitialized(model)
    if Array.isArray(stuffToStore)
      angular.forEach(stuffToStore, (object, idx) =>
        @cache[model][object.id] = object
      )
    else
      object = stuffToStore
      @cache[model][object.id] = object
    return stuffToStore
  
  ensureInitialized: (model) ->
    if typeof(@cache[model]) == "undefined"
      @cache[model] = {}