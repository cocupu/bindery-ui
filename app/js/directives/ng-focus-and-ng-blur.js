// ng-focus and ng-blur will be in stable 2.x releases of angular.  Until then, using a shim.
// This code if from https://gist.github.com/eliotsykes/5394631
angular.module("app").directive('ngFocus', ['$parse', function($parse) {
    return function(scope, element, attr) {
        var fn = $parse(attr['ngFocus']);
        element.bind('focus', function(event) {
            scope.$apply(function() {
                fn(scope, {$event:event});
            });
        });
    };
}]);

angular.module("app").directive('ngBlur', ['$parse', function($parse) {
    return function(scope, element, attr) {
        var fn = $parse(attr['ngBlur']);
        element.bind('blur', function(event) {
            scope.$apply(function() {
                fn(scope, {$event:event});
            });
        });
    };
}]);