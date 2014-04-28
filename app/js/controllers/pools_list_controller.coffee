PoolsListCtrl = ($scope, $stateParams, $location, BinderyPool, context) ->
  $scope.identityName = $stateParams.identityName
  $scope.pools = BinderyPool.query({identityName:$stateParams.identityName}, (data) -> 
    angular.forEach(data, (pool, idx) -> pool.load_overview() )
  )
  
PoolsListCtrl.$inject = ['$scope', '$stateParams', '$location', 'BinderyPool', 'ContextService']
angular.module("app").controller('PoolsListCtrl', PoolsListCtrl)