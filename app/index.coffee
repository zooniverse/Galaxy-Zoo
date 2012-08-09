require 'lib/setup'

Config = require 'lib/config'
Spine = require 'spine'
Api = require 'zooniverse/lib/api'
Navigation = require 'controllers/navigation'
Main = require 'controllers/main'

class App extends Spine.Controller
  constructor: ->
    super
    
    Api.init host: Config.apiHost
    @navigation = new Navigation
    @main = new Main
    
    @append @navigation.active(), @main
    Spine.Route.setup()

module.exports = App
