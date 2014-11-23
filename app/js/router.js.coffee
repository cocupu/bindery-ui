angular.module("app").config( ($stateProvider, $urlRouterProvider) ->

  # For any unmatched url, redirect to /
  $urlRouterProvider.otherwise("/home")

  # Now set up the states
  $stateProvider
    .state('home', {
        url: "/home",
        controller: 'HomeController',
        templateUrl: 'home.html'
      })
    .state('login', {
        url: "/login",
        controller: 'LoginController',
        templateUrl: 'login.html'
      })
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
      controller: 'PoolsListCtrl',
      templateUrl: 'pools/list.html'
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
      templateUrl: "pools/search.html",
      controller: 'PoolSearchCtrl'
    })
    .state('curate.pool.grid', {
      url: "/grid",
      templateUrl: "pools/search.html",
      controller: 'PoolSearchCtrl'
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
    .state('curate.pool.node', {
      url: "/{nodeId}",
      templateUrl: "nodes/edit.html",
      controller: 'NodeEditorCtrl'
    })
  )