Spine = require 'spine'
User = require 'zooniverse/lib/models/user'
Recent = require 'zooniverse/lib/models/recent'
Favorite = require 'zooniverse/lib/models/favorite'
LoginForm = require 'zooniverse/lib/controllers/login_form'

class Profile extends Spine.Controller
  events:
    'click .favs'   : 'displayFavs'
    'click .recents': 'displayRecents'

  elements:
    '.favs'      : 'favs'
    '.recents'   : 'recents'
    '#login'     : 'login'

  user: null

  constructor: ->
    super
    User.bind 'sign-in', @setUser
  
  setUser: =>
    if User.current
      @user = User.current
      Recent.fetch()
      Favorite.fetch()
      @render() if @isActive() 
    else
      @renderLogin() if @isActive()
  
  active: ->
    super
    if @user
      @render()
    else 
      @renderLogin()
    
  render: ->
    @html require('views/profile')(@)

  renderLogin: ->
    @html require('views/login')
    new LoginForm el: @login

  displayRecents: (e) =>
    @thumbs = Recent.all().sort @sortThumbs
    @thumbs = @thumbs.slice(0, 11)
    @render() if @isActive()
    @recents.removeClass 'inactive'
    @favs.addClass 'inactive'

  displayFavs: (e) =>
    @thumbs = Favorite.all().sort @sortThumbs
    @render() if @isActive()
    @recents.addClass 'inactive'
    @favs.removeClass 'inactive'

  sortThumbs: (left, right) ->
    return -1 if left.created_at > right.created_at
    return 1 if left.created_at < right.created_at
    return 0

module.exports = Profile
