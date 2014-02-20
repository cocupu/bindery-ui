describe "service: MemoizationService", ->

  Given -> module("app")
	
  Given -> inject (@memoService) =>
    @item1 = {id:4, "foo":"item1"}
    @item2 = {id:5, "foo":"item2"}
    @item3 = {id:10, "foo":"item3"}
    
  describe "#createOrUpdate and #lookup", ->
    When  -> @memoService.createOrUpdate('BinderyNode', @item1)
    Then 	-> expect(@memoService.lookup('BinderyNode', 4)).toBe( @item1 )
    When  -> @memoService.createOrUpdate('BinderyModel', @item2)
    Then 	-> expect(@memoService.lookup('BinderyModel', 5)).toBe( @item2 )
    # TODO:  chokes when testing #createOrUpdate with arrays
    # When  -> @memoService.createOrUpdate('BinderyModel', [@item2, @item3])
    # Then  -> expect(@memoService.lookup('BinderyModel', 5)).toBe( @item2 )
    # Then  -> expect(@memoService.lookup('BinderyModel', 10)).toBe( @item3 )
