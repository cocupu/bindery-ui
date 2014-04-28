angular.module("app").directive('binderyFacetValue', ['$compile','$location',($compile, $location) ->
  return {
    restrict: 'E'
    template: '<li></li>'
    replace: true
    scope: {
      value: '='
      field: '='
    }
    controller: ['$scope', '$element', ($scope, $element) ->
      $scope.applyFacetLimit = (value) ->
        searchParams = $location.search()
        searchParams["f["+$scope.field.code+"_facet][]"] = encode(value)
#        $location.path( $location.path() ).search(searchParams)
#        $location.replace()
        console.log(searchParams)
        newPath = $location.path() + "?" + $.param(searchParams, true)
        console.log(decodeURIComponent(newPath))
        window.location.href = decodeURIComponent(newPath)
    ]
    link: (scope, element, attrs) ->
      scope.$watch('values', (newValue, oldValue) ->
        # Empty out the Facet list and re-draw with the new values
        element.empty()
        li = document.createElement('li')
        link = $("<a>", {
          text:value
          title:value
          href: "#"
          "ng-click": "applyFacetLimit('"+value+"')"
        }).appendTo(li)
        $("<span class='badge pull-right'>").text(count).appendTo(link)
        $compile(li)(scope)
        element[0].appendChild(li)
      , false)

  }
])