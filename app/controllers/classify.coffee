Spine = require 'spine'
Subject = require 'models/subject'
Classification = require 'models/classification'
Dialog = require 'lib/dialog'
Recent = require 'zooniverse/lib/models/recent'
Favorite = require 'zooniverse/lib/models/favorite'
User = require 'zooniverse/lib/models/user'
LoginForm = require 'zooniverse/lib/controllers/login_form'

class Classify extends Spine.Controller
  elements:
    '#classify .galaxy img': 'image'
    '.tree .question': 'question'
    '.top .buttons .invert': 'invertLink'
    '.top .buttons .favorite': 'favoriteLink'
  
  events:
    'click #classify .galaxy img': 'toggleInverted'
    'click .tree .answer': 'answer'
    'click .tree .checkbox': 'checkBox'
    'click .top .buttons .help': 'help'
    'click .top .buttons .restart': 'restart'
    'click .top .buttons .invert': 'toggleInverted'
    'click .top .buttons .favorite': 'toggleFavorite'
  
  constructor: ->
    super
    
    @classificationCount = 0
    
    $('.example-thumbnail').die('click').live 'click', @showExample
    Subject.bind 'fetched', @nextSubject
    User.bind 'sign-in', @render
    User.bind 'sign-in', @hideLoginPrompt
    Classification.bind 'classified', @loginPrompt
    Subject.next()
  
  active: ->
    super
    @render()
  
  render: =>
    return unless @subject and @isActive()
    @html require('views/classify')(@)
  
  loginPrompt: =>
    unless User.current
      @classificationCount += 1
      
      if @classificationCount is 3
        @loginPrompt = new Dialog
          template: 'views/login_prompt'
          callback: -> @el().remove()
        
        @loginPrompt.show()
        new LoginForm el: '.login-prompt .login'
  
  hideLoginPrompt: =>
    if User.current and $('.login-prompt:visible')[0]
      @loginPrompt.close()
      @loginPrompt.el().remove()
  
  nextSubject: =>
    @subject = Subject.current
    @classification = new Classification subject_id: @subject.id
    @render()
  
  answer: (ev) =>
    answer = $(ev.target).closest '.answer'
    id = answer.data 'id'
    talk = answer.data 'talk'
    
    if talk
      url = "http://talk.galaxyzoo.org/objects/#{ @subject.zooniverse_id }"
      window.open url, '_blank'
      window.focus()
    
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
    else
      @classification.send()
      @finish() # should be a interrupt page for favoriting, info, talk, etc
  
  finish: ->
    Subject.next()
    @nextSubject()

module.exports = Classify
