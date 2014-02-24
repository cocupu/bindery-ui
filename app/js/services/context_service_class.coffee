#  NOTE: I tried rewriting context_service.coffee as a CoffeeScript Class, but it's raising an error because the dependencies (BinderyPool & BinderyIdentity) aren't getting injected.
#  In the meantime, relying on context_service.coffee, which functions the same but the code is ugly.
#
#
# class ContextService
# 	constructor: (BinderyPool, BinderyIdentity) ->
# 	
# 	initialize: (identityName, poolName) ->
#     # Only load resources if identityName is actually set
#     if identityName
#       @identityName = identityName
#       @poolName = poolName
#       @poolUrl = "/"+identityName+"/"+poolName
#       @pool = BinderyPool.get({identityName: identityName, poolName: poolName}, (data) ->
#         @pool.identity_name = identityName
#         @poolOwner = BinderyIdentity.get({name:data.owner_id})
#         @pool.fields()
#       )
# 
# angular.module('curateDeps').service('ContextService', ['BinderyPool', 'BinderyIdentity', ContextService])