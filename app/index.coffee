require 'lib/setup'

Spine = require 'spine'
Navigation = require 'controllers/navigation'
Main = require 'controllers/main'

class App extends Spine.Controller
  constructor: ->
    super
    @navigation = new Navigation
    @main = new Main
    
    @append @navigation.active(), @main
    Spine.Route.setup()

module.exports = App
