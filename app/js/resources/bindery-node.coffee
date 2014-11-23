angular.module('curateDeps').factory('BinderyNode', ['$resource', '$location', 'BinderyModel', 'MemoService', 'BinderyNodeAssociations', 'BinderyServer', ($resource, $location, BinderyModel, MemoService, BinderyNodeAssociations, bindery) ->

  BinderyNode = $resource(bindery.baseUrl+"/:identityName/:poolName/nodes/:nodeId.json", {identityName:'@identity', poolName:'@short_name',nodeId:'@persistent_id'}, {
      update: { method: 'PUT' }
  })

  BinderyNode.prototype.download_url = () ->  $location.path().replace("search","file_entities")+"/"+this.persistent_id
#  BinderyNode.prototype.cache = {}
  BinderyNode.prototype.inbound_associations = () ->
    if (typeof(this.cache) == "undefined")
      this.cache = {}
    if (typeof(this.cache.inbound_associations) == "undefined")
      cache = this.cache
      BinderyNodeAssociations.get({nodeId:this.persistent_id,filter:"incoming"}, (data, getResponseHeaders) ->
        relatedNodes = data["incoming"]
        angular.forEach(relatedNodes, (item, idx) ->
          relatedNodes[idx] = new BinderyNode(item)  #<-- replace each item with an instance of the resource object
        )
        cache.inbound_associations = relatedNodes
      )
    return this.cache.inbound_associations

  BinderyNode.prototype.model = () ->
    model = MemoService.lookup("BinderyModel", this.model_id)
    # If model isn't already in memoService cache, load it and cache it.
    # Note: this assumes behavior of being called repeatedly if it returns nil. (which is how the $digest cycle seems to work)
    if (typeof(model) == "undefined")
      model = BinderyModel.get({modelId: this.model_id}, (data)->
        MemoService.createOrUpdate("BinderyModel", data)
      )
    return model

  return BinderyNode
])