NodeCarouselCtrl = ($scope) ->
    $scope.indexOfActiveSlide = 0

NodeCarouselCtrl.$inject = ['$scope']
angular.module("curateDeps").controller('NodeCarouselCtrl', NodeCarouselCtrl)