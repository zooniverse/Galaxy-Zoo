Spine = require 'spine'
Subject = require 'models/subject'
Classification = require 'models/classification'
Dialog = require 'lib/dialog'

class Classify extends Spine.Controller
  elements:
    '.tree .question': 'question'
  
  events:
    'click .tree .answer a': 'answer'
    'click .top .buttons .help': 'help'
    'click .top .buttons .restart': 'restart'
  
  constructor: ->
    super
    @helpDialog = new Dialog
      template: 'views/help'
      quickHide: true
    
    Subject.bind 'fetched', @nextSubject
    Subject.next()
  
  active: ->
    super
    @render()
  
  render: ->
    return unless @subject
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
  
  updateQuestion: ->
    @finish() unless @classification.question
    @question.html require('views/question')(@classification.question)
  
  finish: ->
    @classification.send()
    Subject.next()
    @nextSubject()

module.exports = Classify
