angular.module('curateDeps').factory('BinderyIdentity', ['$resource', ($resource) ->

  BinderyIdentity = $resource("/identities/:name.json", {name:'@identityName'}, {
    update: { method: 'PUT' }
  })

  return  BinderyIdentity
])