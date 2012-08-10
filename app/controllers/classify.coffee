Spine = require 'spine'
GalaxyZooSubject = require 'models/galaxy_zoo_subject'
Classification = require 'models/classification'

class Classify extends Spine.Controller
  elements:
    '.tree .question': 'question'
  
  events:
    'click .tree .answer a': 'answer'
  
  constructor: ->
    super
    GalaxyZooSubject.bind 'fetched', @nextSubject
    GalaxyZooSubject.next()
  
  active: ->
    super
    @render()
  
  render: ->
    return unless @subject
    @html require('views/classify')(@)
  
  nextSubject: =>
    @subject = GalaxyZooSubject.current
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
    GalaxyZooSubject.next()
    @nextSubject()

module.exports = Classify
