Spine = require 'spine'
GalaxyZooSubject = require 'models/galaxy_zoo_subject'

class Classification extends Spine.Model
  @configure 'Classification', 'subject_id', 'annotations'
  
  constructor: ->
    super
    @annotations = []
    @question = @subject().tree().first()
  
  subject: ->
    GalaxyZooSubject.find @subject_id
  
  annotate: (answerId) ->
    annotation = { }
    annotation[@question.id] = answerId
    @annotations.push annotation
    @question = @question.nextQuestionFrom answerId

module.exports = Classification
