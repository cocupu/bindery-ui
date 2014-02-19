angular.module('curateDeps').factory('searchService', ['BinderyPool', 'BinderyIdentity', (BinderyPool, BinderyIdentity) ->
  searchService = {pool:"", poolOwner:""}

  searchService.initialize = (identityName, poolName) ->
    # Only load resources if identityName is actually set
    if identityName
      contextService.identityName = identityName
      contextService.poolName = poolName
      contextService.poolUrl = "/"+identityName+"/"+poolName
      contextService.pool = BinderyPool.get({identityName: identityName, poolName: poolName}, (data) ->
        contextService.pool.identity_name = identityName
        contextService.poolOwner = BinderyIdentity.get({name:data.owner_id})
        contextService.pool.fields()
      )

  return searchService
])