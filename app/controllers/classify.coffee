Spine = require 'spine'
Subject = require 'models/subject'
Classification = require 'models/classification'

class Classify extends Spine.Controller
  elements:
    '.tree .question': 'question'
  
  events:
    'click .tree .answer a': 'answer'
  
  constructor: ->
    super
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
  
  updateQuestion: ->
    @finish() unless @classification.question
    @question.html require('views/question')(@classification.question)
  
  finish: ->
    @classification.send()
    Subject.next()
    @nextSubject()

module.exports = Classify
