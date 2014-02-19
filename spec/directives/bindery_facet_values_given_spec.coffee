describe "directive: bindery-facet-values", ->

  Given -> module("app")

  Given inject ($rootScope, $compile) ->
    @html = "<bindery-facet-values values='testFacetValues' data-field='focusedField'></div>"
    @scope = $rootScope.$new();
    @scope.testFacetValues = ["Bob",6, "Sally",5, "Atul",5, "Julia",3]
    @scope.focusedField = {code: "author"}
    @elem = $compile(@html)(@scope)

  describe "displays each of the facet values as a link to search on that facet", ->
		Then @elem.find("li") == ""
		Then @scope.testFacetValues == "foo"

