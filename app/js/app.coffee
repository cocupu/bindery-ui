BinderyServer = {
  baseUrl: "http://bindery.cocupu.com"
}

curateDeps = angular.module('curateDeps', ['ng', "ngResource", 'ui.bootstrap', 'ngGrid', 'ngRoute', 'ui.router', 'ui.sortable', 'Devise'])  #, "ngRoute"
curateDeps.factory('BinderyServer', [ () ->
  return BinderyServer
])

app = angular.module("app", ["ngResource", "ngRoute", 'curateDeps'])

app.config(['$httpProvider', ($httpProvider) ->
  $httpProvider.defaults.useXDomain = true;
  delete $httpProvider.defaults.headers.common['X-Requested-With'];
])

app.config(['AuthProvider', (AuthProvider) ->
  AuthProvider.loginPath(BinderyServer.baseUrl+'/users/sign_in.json');
  AuthProvider.logoutPath(BinderyServer.baseUrl+'/users/sign_out.json');
  AuthProvider.registerPath(BinderyServer.baseUrl+'/users.json');
])

app.run( ($rootScope) ->
  # adds some basic utilities to the $rootScope for debugging purposes
  $rootScope.log = (thing) -> console.log(thing)

  $rootScope.alert = (thing) -> alert(thing)
)

Number.prototype.leftZeroPad = (numZeros) ->
  n = Math.abs(this);
  zeros = Math.max(0, numZeros - Math.floor(n).toString().length );
  zeroString = Math.pow(10,zeros).toString().substr(1);
  if ( this < 0 ) 
    zeroString = '-' + zeroString;

  return zeroString+n;