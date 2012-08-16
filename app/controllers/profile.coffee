Config = require 'lib/config'
Spine = require 'spine'
User = require 'zooniverse/lib/models/user'
Recent = require 'zooniverse/lib/models/recent'
Favorite = require 'zooniverse/lib/models/favorite'
LoginForm = require 'zooniverse/lib/controllers/login_form'

class Profile extends Spine.Controller
  events:
    'click .favorites-link' : 'switch'
    'click .recents-link': 'switch'
    'click .item .remove': 'remove'
  
  elements:
    '.favorites-link' : 'favoritesLink'
    '.recents-link' : 'recentsLink'
    '#login'        : 'login'
  
  constructor: ->
    super
    @showing = 'recents'
    User.bind 'sign-in', @setUser
  
  collection: =>
    if @showing is 'recents' then Recent else Favorite
  
  setUser: =>
    if User.current
      @user = User.current
      Favorite.fetch()
      fetcher = @collection().fetch()
      fetcher.onSuccess(@render) if @isActive()
    else
      @user = null
      @renderLogin()
  
  active: ->
    super
    @render()
  
  render: =>
    @renderLogin() unless @user # FIX-ME: Should display a login form instead of just not rendering
    @items = @collection().all()
    @html require('views/profile')(@)

  renderLogin: =>
    @html require('views/login')()
    new LoginForm el: @login
  
  surveyCount: (survey) ->
    @user.project?.groups?[Config.surveys[survey].id]?.classification_count
  
  remove: ({ originalEvent: e }) ->
    item = @collection().find $(e.target).closest('.item').data 'id'
    item.destroy().onSuccess @render
  
  switch: ({ originalEvent: e }) ->
    toShow = $(e.target).closest('a').data 'show'
    return if toShow is @showing
    @showing = toShow
    @render()
  
module.exports = Profile
