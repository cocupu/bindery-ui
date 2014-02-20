describe "service: ContextService", ->

  Given -> module("app")
	
  Given -> inject ($http, @ContextService) =>
	
  describe "#initialize", ->
    When -> @ContextService.initialize("theIdentity", "aPool")
    Then -> expect(@ContextService.poolUrl).toBe("/theIdentity/aPool")
		# Then -> expect(BinderyPool.get).toHaveBeenCalledWith({identityName: "theIdentity", poolName: "aPool"})
		#    	Then -> expect(@contextService.pool).toBe("")
		# Then -> expect(@contextService.pool.poolOwner).toBe("")