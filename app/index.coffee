
require 'lib/setup'

Config = require 'lib/config'
Spine = require 'spine'
Api = require 'zooniverse/lib/api'
Navigation = require 'controllers/navigation'
Main = require 'controllers/main'
Quizzes = require 'controllers/quizzes'
TopBar = require 'zooniverse/lib/controllers/top_bar'
FastClick = require 'lib/fastclick'

class App extends Spine.Controller
  constructor: ->
    super
    
    # new FastClick(document.body)

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
    # $("body").on 'touchend', =>
    #   if $("body").scrollTop() < 20
    #     $("body").animate({scrollTop: 0}, 200)
    #   else if $("body").scrollTop() > 20 and $("body").scrollTop() < 40
    #     $("body").animate({scrollTop:40}, 200)
    Spine.Route.setup()

    Spine.Route.bind "change", (nav)=>
      console.log "nav is ", nav
      @hideNav()
      

    setTimeout =>
      @hideNav()
    , 2000 


  hideNav:=>
    setTimeout =>
        $("#contentWrapper").animate({scrollTop:60},400)
      , 400

  showNav:=>
    setTimeout =>
        $("#contentWrapper").animate({scrollTop:0},400)
      , 400

preload = (image) ->
  img = new Image
  img.src = image

$ ->
  preload '/images/icons.png'
  preload '/images/workflow.png'
  preload '/images/examples.png'

module.exports = App
