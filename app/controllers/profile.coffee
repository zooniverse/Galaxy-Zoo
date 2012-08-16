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
  
  constructor: ->
    super
    @showing = 'recents'
    User.bind 'sign-in', @refresh
  
  collection: =>
    if @showing is 'recents' then Recent else Favorite
  
  user: ->
    User.current
  
  refresh: =>
    if User.current
      fetcher = @collection().fetch()
      fetcher.onSuccess(@render) if @isActive()
  
  active: ->
    super
    @render()
  
  render: =>
    if User.current
      @html require('views/profile')(@)
    else
      @html require('views/login')()
      new LoginForm el: '#login'
  
  surveyCount: (survey) ->
    User.current.project?.groups?[Config.surveys[survey].id]?.classification_count
  
  remove: ({ originalEvent: e }) ->
    item = @collection().find $(e.target).closest('.item').data 'id'
    item.destroy().onSuccess @render
  
  switch: ({ originalEvent: e }) ->
    toShow = $(e.target).closest('a').data 'show'
    return if toShow is @showing
    @showing = toShow
    @collection().fetch().onSuccess @render

module.exports = Profile
