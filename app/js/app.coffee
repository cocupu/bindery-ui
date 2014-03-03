angular.module('curateDeps', ['ng', "ngResource", "ngSanitize", 'ngGrid', 'ui.router'])  #, "ngRoute"
app = angular.module("app", ["ngResource", "ngRoute", 'curateDeps'])

app.config(['$httpProvider', ($httpProvider) ->
  $httpProvider.defaults.useXDomain = true;
  delete $httpProvider.defaults.headers.common['X-Requested-With'];
])

app.run( ($rootScope) ->
  # adds some basic utilities to the $rootScope for debugging purposes
  $rootScope.log = (thing) -> console.log(thing)

  $rootScope.alert = (thing) -> alert(thing)
)
