# dependency - Function.prototype.bind or underscore/lodash
# Based on code by Elad Ossadon from http://www.devign.me/angular-dot-js-coffeescript-controller-base-class
 
# The constructor will  
# * handle dependency injection for you based on dependencies passed to @inject in your Class definition
class @AngularService
  # Register this Class as a controller in the specified app/module
  @register: (app, name) ->
    name ?= @name || @toString().match(/function\s*(.*?)\(/)?[1]
    app.service name, @
    
  # Declare which dependencies should be injected by constructor
  @inject: (args...) ->
    @$inject = args
 
  constructor: (args...) ->
    # console.log("With $inject: "+@constructor.$inject)
    for key, index in @constructor.$inject
      # console.log("  injecting "+key)
      # console.log(args[index])
      @[key] = args[index]
      
    @initialize?()