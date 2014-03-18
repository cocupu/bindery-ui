angular.module("app").config( ($stateProvider, $urlRouterProvider) ->

  # For any unmatched url, redirect to /state1
  $urlRouterProvider.otherwise("/state1")

  # Now set up the states
  $stateProvider
    .state('identity', {
      abstract: true,
      url: "/identity/{identityName}",
      template: '<ui-view/>'
    })
    .state('identity.default', {
      url: "",
      template: '<h3>Identity</h3><ui-view/>'
    })
    .state('identity.pools', {
      url: "/pools",
      template: '<h3>Pools List</h3><ui-view/>'
    })
    .state('curate', {
      url: "/pool/{identityName}",
      template: '<ui-view/>'
    })
    .state('curate.pool', {
      abstract: true,
      url: "/{poolName}",
      template: '<ui-view/>'
    })
    .state('curate.pool.default', {
      url: "",
      templateUrl: "grid_with_headsup.html",
      controller: 'GridWithHeadsupCtrl'
    })
    .state('curate.pool.grid', {
      url: "grid",
      templateUrl: "grid_with_headsup.html",
      controller: 'GridWithHeadsupCtrl'
    })
    .state('curate.pool.models', {
      url: "/models",
      templateUrl: "models/list.html",
      controller: 'ModelsListCtrl'
    })
    .state('curate.pool.models.edit', {
      url: "/{modelId}",
      templateUrl: "models/edit.html",
      controller: 'ModelEditorCtrl'
    })
    .state('curate.pool.perspectives', {
      url: "/perspectives",
      templateUrl: "pools/edit.html",
      controller: 'PoolEditorCtrl'
    })
    .state('curate.pool.admin', {
      url: "/admin",
      templateUrl: "pools/edit.html",
      controller: 'PoolEditorCtrl'
    })
  )