Spine = require 'spine'
Subject = require 'models/subject'
Classification = require 'models/classification'
Dialog = require 'lib/dialog'
Recent = require 'zooniverse/lib/models/recent'
Favorite = require 'zooniverse/lib/models/favorite'
User = require 'zooniverse/lib/models/user'
UserGroup = require 'models/user_group'
LoginForm = require 'zooniverse/lib/controllers/login_form'
Intervention = require 'lib/intervention'
Analytics = require 'lib/analytics'

window.delay = (ms, fn)-> setTimeout(fn, ms)
window.timer = (ms, fn)-> setInterval(fn, ms)

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
    'click #dismiss-intervention': 'dismissIntervention'
    'click #intervention-talk-link': 'exitToTalk'

  constructor: ->
    super

    timer 10000, Intervention.checkForAndProcessIntervention

    @classificationCount = 0

    $('.example-thumbnail').die('click').live 'click', @showExample
    Subject.bind 'fetched', @nextSubject
    User.bind 'sign-in', @render
    User.bind 'sign-in', @hideLoginPrompt
    UserGroup.bind 'participate', @render
    Classification.bind 'classified', @loginPrompt
    Subject.next()
    $('#zooniverse-top-bar-login .buttons button[name="signup"]').unbind('click').bind 'click', @signupPrompt

  active: ->
    super
    @render()

  render: =>
    return unless @isActive()
    if @subject
      if Intervention.isInterventionNeeded()
        @renderIntervention = true
        @messageToUse = "classify.bgu_ms_exp1_intervention_text_#{Intervention.getNextIntervention()?.preconfigured_id}"
        delay 1000,@showIntervention
      else
        @renderIntervention = false
      @html require('views/classify')(@)
    else
      @html '''
        <div id="classify" class="down-for-maintenance hidden">
          <p style="text-align: center;">Galaxy Zoo is currently down for maintenance&mdash;we're looking for more galaxies!</p>
        </div>
      '''
      setTimeout => @$('#classify').removeClass 'hidden'

  loginPrompt: =>
    unless User.current
      @classificationCount += 1

      if @classificationCount in [3, 9]
        @loginPrompt = new Dialog
          template: 'views/login_prompt'
          callback: -> @el().remove()

        @loginPrompt.show()
        new LoginForm el: '.login-prompt .login'

  showIntervention: =>
    if !@interventionAlreadyPresent
      $('.intervention').effect("slide",{"direction":"right","mode":"show"},1000)
      @interventionAlreadyPresent = true
      delay Intervention.getNextIntervention()?.presentation_duration * 1000, @completeIntervention
      Intervention.logInterventionDelivered()

  dismissIntervention: (e) =>
    e.preventDefault
    @renderIntervention = false
    @interventionAlreadyPresent = false
    Intervention.logInterventionDismissed()
    $('.intervention').effect("slide",{"direction":"right","mode":"hide"},1000)

  completeIntervention: () =>
    Intervention.logInterventionCompleted()
    if @interventionAlreadyPresent
      $('.intervention').effect("slide",{"direction":"right","mode":"hide"},1000)
      @interventionAlreadyPresent = false

  exitToTalk: () =>
    Intervention.exitToTalk()

  signupPrompt: (ev) =>
    @loginPrompt = new Dialog
      template: 'views/signup_prompt'
      callback: -> @el().remove()

    @loginPrompt.show()
    loginForm = new LoginForm el: '.login-prompt .login'
    loginForm.signUp()

  hideLoginPrompt: =>
    if User.current and $('.login-prompt:visible')[0]
      @loginPrompt.close()
      @loginPrompt.el().remove()

  nextSubject: =>
    @subject = Subject.current
    @classification = new Classification subject_id: @subject.id
    @render()

    setTimeout =>
      if @subject.showInverted() then @toggleInverted()
  
  answer: (ev) =>
    answer = $(ev.target).closest '.answer'
    id = answer.data 'id'
    talk = answer.data 'talk'

    if talk
      url = "http://talk.galaxyzoo.org/#/subjects/#{ @subject.zooniverse_id }"
      window.open url, '_blank'
      window.focus()

    checks = _ $('.buttons .active.checkbox')
    checkIds = checks.collect (check) -> $(check).data('id')

    @classification.annotate id, checkIds
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
    if @atEnd() or @talkHidden()
      @classification.send()
      @finish()
    else
      @question.html require('views/question')(@classification.question)

  talkHidden: ->
    @classification.question.isTalk() and UserGroup.current?.metadata?.hide_talk

  atEnd: ->
    !@classification.question

  finish: ->
    Subject.next()
    @nextSubject()

module.exports = Classify
