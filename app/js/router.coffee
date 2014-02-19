angular.module('app').config( ['$routeProvider', '$locationProvider', '$httpProvider', ($routeProvider, $locationProvider, $httpProvider) ->
  # enable html5Mode for pushstate ('#'-less URLs)
  $locationProvider.html5Mode(true);
  $locationProvider.hashPrefix('!');

  $routeProvider.
  when('/:identityName/new', {
    controller: 'PoolEditorCtrl'
    templateUrl: '/assets/angular/partials/pool-new.html'
  }).
  when('/:identityName/:poolName/edit', {
    controller: 'PoolEditorCtrl'
    templateUrl: '/assets/angular/partials/pool-editor.html'
  }).
  when('/:identityName/:poolName/search', {
    controller: 'GridWithHeadsupCtrl'
  }).
  when('/:identityName/:poolName/mapping_templates/:action', {
    controller: 'MappingTemplateEditorCtrl'
    templateUrl: '/assets/angular/partials/mapping-template-editor.html'
  }).
  when('/:identityName/:poolName/spawn_jobs/:action', {
  controller: 'SpawnJobEditorCtrl'
  templateUrl: '/assets/angular/partials/spawn-job-editor.html'
  }).
  otherwise({
    redirectTo: '/login'
  })

  # Use Rails csrf token with http requests
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')


])
