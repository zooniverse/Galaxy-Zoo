Spine = require 'spine'
User = require 'zooniverse/lib/models/user'
Recent = require 'zooniverse/lib/models/recent'
Favorite = require 'zooniverse/lib/models/favorite'

class Profile extends Spine.Controller
  events:
    'click .favs'   : 'displayFavs'
    'click .recents': 'displayRecents'

  elements:
    '.favs'      : 'favs'
    '.recents'   : 'recents'

  user: null

  constructor: ->
    super
    User.bind 'sign-in', @setUser
  
  setUser: =>
    @user = User.current
    Recent.fetch()
    if @isActive() and @user
      @render()
  
  active: ->
    super
    if @user
      @render()
    
  render: ->
    @html require('views/profile')(@)

  renderLogin: ->

  displayRecents: (e) =>
    @thumbs = Recent.all().sort @sortThumbs
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
