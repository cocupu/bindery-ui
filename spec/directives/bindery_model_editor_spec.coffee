# describe("directive: bindery-model-editor", () ->
# 
#   beforeEach( () ->
#     module("app")
#   )
# 
#   beforeEach(inject( ($rootScope, $compile, BinderyModel) ->
#     this.subject = new BinderyModel({})
#     this.html = "<div bindery-model-editor='" + this.subject + "'></div>"
#     this.scope = $rootScope.$new()
#     this.elem = $compile(this.html)(this.scope)
#   ))
# 
#   it("displays controls for each of the fields in the model", () ->
#     expect(this.scope.message).toBe(this.directiveMessage);
#   )
# 
# )
