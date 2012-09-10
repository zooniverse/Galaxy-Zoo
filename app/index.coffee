require 'lib/setup'

Config = require 'lib/config'
Spine = require 'spine'
Api = require 'zooniverse/lib/api'
Navigation = require 'controllers/navigation'
Main = require 'controllers/main'
Quizzes = require 'controllers/quizzes'
TopBar = require 'zooniverse/lib/controllers/top_bar'
googleAnalytics = require 'zooniverse/lib/google_analytics'

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
    @quizzes = new Quizzes
    
    @append @navigation.active(), @main
    Spine.Route.setup()

preload = (image) ->
  img = new Image
  img.src = image

$ ->
  preload '/images/icons.png'
  preload '/images/workflow.png'
  preload '/images/examples.png'

googleAnalytics.init account: 'UA-1224199-9', domain: 'galaxyzoo.org'

module.exports = App
