Spine = require 'spine'
Recent = require 'models/project_recent'
User = require 'zooniverse/lib/models/user'

class Home extends Spine.Controller
  elements:
    '.recents'  : 'recentsContainer'
    'form'      : 'loginForm'
    '.username' : 'usernameInput'
    '.password' : 'passwordInput'
    

  events:
    'tap .submitButton' : 'loginSubmit'
    'tap .classifyMore' : 'classifyMore'
      
  constructor: ->
    super
    @recents or= []

    @updateRecents()
    @attemptLocalStorageLogin()

    User.bind 'sign-in' , =>
      if User.current? 
        @render()

    @render()
  
  classifyMore :=>
    @navigate '/classify'  
  

  active: ->
    super

  attemptLocalStorageLogin:->
    username = window.localStorage['7147821400']
    password = window.localStorage['3298168253']
    if username? and password?
      User.login({username, password})

  storeLocal:(username, password)->
    window.localStorage['7147821400'] = username
    window.localStorage['3298168253'] = password


  loginSubmit: (e)=>
    e.preventDefault()
    User.login({username: @usernameInput.val(), password: @passwordInput.val() });
    @storeLocal(@usernameInput.val(), @passwordInput.val())

  updateRecents: =>
    console.log "getting recents"
    # return unless @isActive()
    # return if @recentsFetcher?
    console.log "reall getting recents"
    @recentsFetcher = Recent.fetch(10).onSuccess (subjects) =>
      console.log "got recent reply"
      @recents = Recent.all()
      @recentsContainer.html require('views/recents')(@recents)
      @recentsFetcher = null
   
   
  
  render: ->
    @html require('views/home')
      recents : @recents
      user    : User.current


module.exports = Home
