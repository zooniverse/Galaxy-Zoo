require 'lib/setup'

Config = require 'lib/config'
Spine = require 'spine'
Api = require 'zooniverse/lib/api'
Navigation = require 'controllers/navigation'
Main = require 'controllers/main'
Quiz = require 'controllers/quiz'
TopBar = require 'zooniverse/lib/controllers/top_bar'

class App extends Spine.Controller
  constructor: ->
    super
    
    Api.init host: Config.apiHost
    @topBar = new TopBar
      el: '.zooniverse-top-bar'
      languages:
        en: 'English'
      app: 'galaxy_zoo'
    
    @navigation = new Navigation
    @main = new Main
    @quiz = new Quiz
    
    @append @navigation.active(), @main
    Spine.Route.setup()

module.exports = App
