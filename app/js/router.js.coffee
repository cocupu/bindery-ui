angular.module("app").config( ($stateProvider, $urlRouterProvider) ->

  # For any unmatched url, redirect to /state1
  $urlRouterProvider.otherwise("/state1")

  # Now set up the states
  $stateProvider
    .state('identity', {
      url: "/{identityName}",
      templateUrl: "identity.html",
    })
    .state('identity.pool', {
      url: "/{poolName}",
      templateUrl: "grid_with_headsup.html",
      controller: 'GridWithHeadsupCtrl'
    })
  )