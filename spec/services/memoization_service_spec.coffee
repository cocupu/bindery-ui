describe "service: MemoizationService", ->

  Given -> module("app")
    
  Given -> inject (@MemoService) =>
    @item1 = {id:4, "foo":"item1"}
    @item2 = {id:5, "foo":"item2"}
    @item3 = {id:10, "foo":"item3"}
    
  describe "#createOrUpdate and #lookup", ->
    When  -> @MemoService.createOrUpdate('BinderyNode', @item1)
    Then 	-> expect(@MemoService.lookup('BinderyNode', 4)).toBe( @item1 )
    When  -> @MemoService.createOrUpdate('BinderyModel', @item2)
    Then 	-> expect(@MemoService.lookup('BinderyModel', 5)).toBe( @item2 )
    When  -> @MemoService.createOrUpdate('BinderyModel', [@item2, @item3])
    Then  -> expect(@MemoService.lookup('BinderyModel', 5)).toBe( @item2 )
    Then  -> expect(@MemoService.lookup('BinderyModel', 10)).toBe( @item3 )
