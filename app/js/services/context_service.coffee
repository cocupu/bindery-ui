# Tracks context within DataBindery
# particularly the current Identity, Pool, and corresponding base URL for requests
class ContextService extends AngularService
  @register angular.module('curateDeps')
  @inject 'BinderyServer', 'BinderyPool', 'BinderyIdentity'

  initialize: (identityName, poolName) ->
    # Only load resources if identityName is actually set
    if identityName
      @identityName = identityName

      if poolName
        @poolName = poolName
        @poolUrl = "/"+@identityName+"/"+@poolName
        @pool = @BinderyPool.get({identityName: identityName, poolName: poolName}, (data) =>
          @pool.identity = identityName
          @poolOwner = @BinderyIdentity.get({name:data.owner_id})
          @pool.fields()
          @pool.models()
        )