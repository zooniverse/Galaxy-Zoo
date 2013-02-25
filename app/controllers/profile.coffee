Config = require 'lib/config'
Spine = require 'spine'
User = require 'zooniverse/lib/models/user'
Recent = require 'zooniverse/lib/models/recent'
Favorite = require 'zooniverse/lib/models/favorite'
LoginForm = require 'zooniverse/lib/controllers/login_form'
Quiz = require 'models/quiz'

class Profile extends Spine.Controller
  events:
    'click .item img': 'examine'
    'click .item .inactive.remove': 'removeFavorite'
    'click .item .active.favorite': 'removeFavorite'
    'click .item .inactive.favorite': 'addFavorite'
    'click .quizzes .take-a-quiz': 'takeQuiz'
    'click .next-link' : 'next'
    'click .prev-link' : 'prev'
  
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
  
  user: ->
    User.current
  
  refresh: =>
    if User.current && @isActive()
      @collection().deleteAll()
      fetcher = @collection().fetch(@opts)
      fetcher.onSuccess(@render) if @isActive()
  
  active: (params) ->
    super
    @showing = params.type or 'recents'
    @opts.page = parseInt(params.page) or 1 
    @render()
    @refresh()
  
  render: =>
    if User.current
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

  next: (ev) =>
    @collection().deleteAll()
    if @max? and @max < (@opts.page + 1)
      @opts.page = 1
      @collection.fetch(@opts).onSuccess @render
    else
      @opts.page = @opts.page + 1
      @collection().fetch(@opts).onSuccess =>
        if @collection().count() is 0
          @max = @opts.page - 1
          @opts.page = 1
          @collection().fetch(@opts).onSuccess @render
          @navigate "/profile/#{@showing}/#{@opts.page}", false
        else
          @render()
          @navigate "/profile/#{@showing}/#{@opts.page}", false
          

  prev: (ev) =>
    @collection().deleteAll()
    if (@opts.page - 1) <= 0
      if @max?
        @opts.page = @max
      else
        @opts.page = @opts.page + 1
    else
      @opts.page = @opts.page - 1
    @collection().fetch(@opts).onSuccess @render
    @navigate "/profile/#{@showing}/#{@opts.page}", false
  
module.exports = Profile
