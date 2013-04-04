Config = require 'lib/config'
Spine = require 'spine'
User = require 'zooniverse/lib/models/user'
Recent = require 'zooniverse/lib/models/recent'
Favorite = require 'zooniverse/lib/models/favorite'
LoginForm = require 'zooniverse/lib/controllers/login_form'
Quiz = require 'models/quiz'

class Profile extends Spine.Controller
  events:
    'tap .favorites-link' : 'switch'
    'tap .recents-link': 'switch'
    'tap .item img': 'examine'
    'tap .item .inactive.remove': 'removeFavorite'
    'tap .item .active.favorite': 'removeFavorite'
    'tap .item .inactive.favorite': 'addFavorite'
    'tap .quizzes .take-a-quiz': 'takeQuiz'
    'tap .signout' : 'signout'

  elements:
    '.favorites-link' : 'favoritesLink'
    '.recents-link' : 'recentsLink'
  
  constructor: ->
    super
    @showing = 'recents'
    @opts =
      per_page: 12
    User.bind 'sign-in', @refresh
    Quiz.bind 'quiz-user', @render
    Quiz.bind 'quiz-finished', @render
  
  collection: =>
    if @showing is 'recents' then Recent else Favorite
  
  signout:=>
    User.logout()
    @navigate("/")

  user: ->
    User.current
  
  refresh: =>
    console.log "refreshing"
    if User.current && @isActive()
      console.log "actually refreshing ", @collection()
      fetcher = @collection().fetch(@opts)
      fetcher.onSuccess(@render) if @isActive()
  
  active: ->
    super
    @render()
    @refresh()
  
  render: =>
    if User.current
      console.log "rendering"
      @html require('views/profile')(@)
    else
      @html require('views/login')()
      new LoginForm el: '#login'
  
  quizCount: ->
    Quiz.classificationCount
  
  takeQuiz: ->
    Quiz.next required: false
  
  surveyCount: (survey) ->
    User.current.project?.groups?[Config.surveys[survey].id]?.classification_count or 0
  
  removeFavorite: (ev) ->
    item = @collection().find $(ev.target).closest('.item').data 'id'
    item.unfavorite().onSuccess @render
    ev.preventDefault()
  
  addFavorite: (ev) ->
    item = @collection().find $(ev.target).closest('.item').data 'id'
    item.favorite().onSuccess @render
    ev.preventDefault()
  
  examine: (ev) ->
    item = @collection().find $(ev.target).closest('.item').data 'id'
    @navigate "/examine/#{ item.subjects.zooniverse_id }"
  
  switch: (ev) =>
    toShow = $(ev.target).closest('a').data 'show'
    return if toShow is @showing
    @showing = toShow
    @collection().fetch(@opts).onSuccess @render

module.exports = Profile
