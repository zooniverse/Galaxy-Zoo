Spine = require 'spine'
Subject = require 'models/subject'
Classification = require 'models/classification'
Dialog = require 'lib/dialog'
Recent = require 'zooniverse/lib/models/recent'
Favorite = require 'zooniverse/lib/models/favorite'
User = require 'zooniverse/lib/models/user'

class Classify extends Spine.Controller
  elements:
    '#classify .galaxy img': 'image'
    '.tree .question': 'question'
    '.top .buttons .invert': 'invertLink'
    '.top .buttons .favorite': 'favoriteLink'
  
  events:
    'tap #classify .galaxy img': 'toggleInverted'
    'tap .tree .answer': 'answer'
    'tap .tree .checkbox': 'checkBox'
    'tap .top .buttons .help': 'help'
    'tap .top .buttons .restart': 'restart'
    'tap .top .buttons .invert': 'toggleInverted'
    'tap .top .buttons .favorite': 'toggleFavorite'
  
  constructor: ->
    super
    
    $('.example-thumbnail').die('click').live 'click', @showExample
    Subject.bind 'fetched', @nextSubject
    User.bind 'sign-in', @render
    Subject.next()
    @render()

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
  
  answer: (ev) ->
    console.log("trigger answer")
    id = $(ev.target).closest('.answer').data 'id'
    console.log("id is #{id}")
    checks = _ $('.buttons .active.checkbox')
    checkIds = checks.collect (check) -> $(check).data('id')
    
    if checkIds.length is 0
      @classification.annotate id
    else
      @classification.annotate checkIds
    
    @updateQuestion()
    ev.preventDefault()
  
  checkBox: (ev) ->
    item = $(ev.target).closest('.checkbox')
    item.toggleClass 'active'
  
  help: (ev) ->
    @helpDialog = new Dialog
      template: 'views/help'
      quickHide: true
      closeButton: true
      callback: -> @el().remove()
    
    @helpDialog.question = @classification.question
    @helpDialog.show()
    ev.preventDefault()
  
  restart: (ev) ->
    @classification = new Classification subject_id: @subject.id
    @render()
    ev.preventDefault()
  
  toggleInverted: (ev) ->
    if @image.hasClass 'inverted'
      @image.attr 'src', Subject.current.location.standard
    else
      @image.attr 'src', Subject.current.location.inverted
    
    @invertLink.toggleClass 'active'
    @image.toggleClass 'inverted'
  
  toggleFavorite: (ev) ->
    @favoriteLink.toggleClass 'active'
    @classification.isFavorited = @favoriteLink.hasClass 'active'
    ev.preventDefault()
  
  showExample: (ev) =>
    dialog = new Dialog
      template: 'views/example'
      quickHide: true
      closeButton: true
    
    dialog.example = $(ev.target).closest('.example-thumbnail').data 'example'
    dialog.show()
    dialog.el().find('.dialog').css 'height', @helpDialog.el().find('.dialog').height()
    ev.preventDefault()
  
  updateQuestion: ->
    if @classification.question
      @question.html require('views/question')(@classification.question)
      setTimeout =>
        @updateScroll(@classification.question)
      ,200
    else
      @classification.send()
      @finish() # should be a interrupt page for favoriting, info, talk, etc
  
  updateScroll:(question)=>
    answerCount = (key for key,val of question.answers).length
    checkboxCount = (key for key,val of question.checkboxes).length
    displayCount = Math.max(answerCount,checkboxCount)

    console.log "updating scroll with question ", displayCount
    window.currentQuestion = question
    if displayCount > 6
      $("#contentWrapper").animate({scrollTop : 270}, 400)
    else if displayCount > 3
      $("#contentWrapper").animate({scrollTop : 170}, 400)
    else
      $("#contentWrapper").animate({scrollTop : 50}, 400)

  finish: ->
    Subject.next()
    @nextSubject()

module.exports = Classify
