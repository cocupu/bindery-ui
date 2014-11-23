angular.module('curateDeps').factory('BinderyIdentity', ['$resource','BinderyServer', ($resource,bindery) ->

  BinderyIdentity = $resource(bindery.baseUrl+"/identities/:name.json", {name:'@identityName'}, {
    update: { method: 'PUT' }
  })

  return  BinderyIdentity
])