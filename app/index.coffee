require 'lib/setup'

Config = require 'lib/config'
Spine = require 'spine'
Api = require 'zooniverse/lib/api'
Navigation = require 'controllers/navigation'
Main = require 'controllers/main'
Quizzes = require 'controllers/quizzes'
TopBar = require 'zooniverse/lib/controllers/top_bar'
googleAnalytics = require 'zooniverse/lib/google_analytics'
BrowserCheck = require 'zooniverse/lib/controllers/browser_check'
Analytics = require 'lib/analytics'
User = require 'zooniverse/lib/models/user'

class App extends Spine.Controller
  constructor: ->
    super
   
    Api.init host: Config.apiHost
    @topBar = new TopBar
      el: '.zooniverse-top-bar'
      languages:
        en: 'English'
      app: 'galaxy_zoo'
      appName: 'Galaxy Zoo'
    
    @navigation = new Navigation
    @main = new Main
    
    if Config.quizzesActive?
      @quizzes = new Quizzes
    
    @append @navigation.active(), @main
    Spine.Route.setup()

preload = (image) ->
  img = new Image
  img.src = image

for image in ['icons.png', 'workflow.png', 'examples.jpg', 'gz-icon-hubble.png', 'gz-icon-sdss.png', 'gz-icon-ukidss.png', 'gz-icon-quizzes.png']
  preload "/images/#{ image }"

googleAnalytics.init account: 'UA-1224199-9', domain: 'galaxyzoo.org'

(new BrowserCheck).check()

$(window).bind('beforeunload', (e) ->
    Analytics.logEvent { 'type' : 'leave' }
    event.preventDefault()
)

recordLoginLogout = =>
  if User.current?
    Analytics.logEvent { 'type' : 'login' }
  else
    Analytics.logEvent { 'type' : 'logout' }

User.bind('sign-in', recordLoginLogout);

module.exports = App
