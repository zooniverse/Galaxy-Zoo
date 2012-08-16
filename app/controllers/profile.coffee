Config = require 'lib/config'
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
  
  constructor: ->
    super
    User.bind 'sign-in', @setUser
  
  setUser: =>
    @user = User.current
    fetcher = Recent.fetch()
    fetcher.onSuccess(@render) if @isActive()
  
  active: ->
    super
    @render()
  
  render: =>
    return unless @user # FIX-ME: Should display a login form instead of just not rendering
    @html require('views/profile')(@)
  
  surveyCount: (survey) ->
    @user.project?.groups?[Config.surveys[survey].id]?.classification_count
  
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
