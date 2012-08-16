Spine = require 'spine'
Subject = require 'models/subject'
Classification = require 'models/classification'
Dialog = require 'lib/dialog'
Recent = require 'zooniverse/lib/models/recent'
Favorite = require 'zooniverse/lib/models/favorite'
User = require 'zooniverse/lib/models/user'

class Classify extends Spine.Controller
  elements:
    '.tree .question': 'question'
    '.top .buttons .favorite': 'favoriteLink'
  
  events:
    'click .tree .answer a': 'answer'
    'click .top .buttons .help': 'help'
    'click .top .buttons .restart': 'restart'
    'click .top .buttons .favorite': 'toggleFavorite'
  
  constructor: ->
    super
    @helpDialog = new Dialog
      template: 'views/help'
      quickHide: true
      closeButton: true
    
    Subject.bind 'fetched', @nextSubject
    User.bind 'sign-in', @render
    Subject.next()
  
  active: ->
    super
    @render()
  
  render: =>
    return unless @subject and @isActive()
    @html require('views/classify')(@)
  
  nextSubject: =>
    @subject = Subject.current
    @classification = new Classification subject_id: @subject.id
    @render()
  
  answer: ({ originalEvent: e }) ->
    id = $(e.target).closest('a').data 'id'
    @classification.annotate id
    @updateQuestion()
    e.preventDefault()
  
  help: (ev) ->
    @helpDialog.show()
    ev.preventDefault()
  
  restart: (ev) ->
    @classification = new Classification subject_id: @subject.id
    @render()
    ev.preventDefault()
  
  toggleFavorite: (ev) ->
    @favoriteLink.toggleClass 'active'
    @classification.isFavorited = @favoriteLink.hasClass 'active'
    ev.preventDefault()
  
  updateQuestion: ->
    if @classification.question
      @question.html require('views/question')(@classification.question)
    else
      @classification.send()
      @addToRecents() if User.current
      @finish() # should be a interrupt page for favoriting, info, talk, etc
  
  finish: ->
    Subject.next()
    @nextSubject()
  
  addToRecents: ->
    Recent.create
      subjects: Subject.current
      created_at: new Date

module.exports = Classify
