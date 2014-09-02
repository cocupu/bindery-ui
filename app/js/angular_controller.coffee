# dependency - Function.prototype.bind or underscore/lodash
# Based on code by Elad Ossadon from http://www.devign.me/angular-dot-js-coffeescript-controller-base-class
 
# This is a convenience class that simplifies interactions with Angular's dependency injection and allows you to write Class Methods that will automatically be bound to the Controller's scope.
# The constructor will  
# * handle dependency injection for you based on dependencies passed to @inject in your Class definition
# * Bind Class Methods to the Controller $scope
class @AngularController
  
  # Register this Class as a controller in the specified app/module
  @register: (app, name) ->
    name ?= @name || @toString().match(/function\s*(.*?)\(/)?[1]
    app.controller name, @
 
  # Declare which dependencies should be injected by constructor
  @inject: (args...) ->
    @$inject = args
 
  constructor: (args...) ->
    for key, index in @constructor.$inject
      @[key] = args[index]
      
    # Bind Class Methods to Controller $scope
    for key, fn of @constructor.prototype
      continue unless typeof fn is 'function'
      continue if key in ['constructor', 'initialize'] or key[0] is '_'
      @$scope[key] = fn.bind?(@) || _.bind(fn, @)
 
    @initialize?()