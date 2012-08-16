Config = require 'lib/config'
Spine = require 'spine'
User = require 'zooniverse/lib/models/user'
Recent = require 'zooniverse/lib/models/recent'
Favorite = require 'zooniverse/lib/models/favorite'

class Profile extends Spine.Controller
  events:
    'click .favorites-link' : 'switch'
    'click .recents-link': 'switch'
    'click .item .remove': 'remove'
  
  elements:
    '.favorites-link' : 'favoritesLink'
    '.recents-link' : 'recentsLink'
  
  constructor: ->
    super
    @showing = 'recents'
    User.bind 'sign-in', @setUser
  
  collection: =>
    if @showing is 'recents' then Recent else Favorite
  
  setUser: =>
    @user = User.current
    fetcher = @collection().fetch()
    fetcher.onSuccess(@render) if @isActive()
  
  active: ->
    super
    @render()
  
  render: =>
    return unless @user # FIX-ME: Should display a login form instead of just not rendering
    @items = @collection().all()
    @html require('views/profile')(@)
  
  surveyCount: (survey) ->
    @user.project?.groups?[Config.surveys[survey].id]?.classification_count
  
  remove: ({ originalEvent: e }) ->
    item = @collection().find $(e.target).closest('.item').data 'id'
    item.destroy().onSuccess @render
  
  switch: ({ originalEvent: e }) ->
    toShow = $(e.target).closest('a').data 'show'
    return if toShow is @showing
    @showing = toShow
    @recentsLink.toggleClass 'inactive'
    @favoritesLink.toggleClass 'inactive'
    @collection().fetch().onSuccess @render
  
module.exports = Profile
