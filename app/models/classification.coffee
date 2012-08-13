Spine = require 'spine'
Api = require 'zooniverse/lib/api'
Subject = require 'models/subject'

class Classification extends Spine.Model
  @configure 'Classification', 'subject_id', 'annotations'
  
  constructor: ->
    super
    @annotations = []
    @question = @subject().tree().first()
  
  subject: ->
    Subject.find @subject_id
  
  annotate: (answerId) ->
    annotation = { }
    annotation[@question.id] = answerId
    @annotations.push annotation
    @question = @question.nextQuestionFrom answerId
  
  url: ->
    "/projects/galaxy_zoo/workflows/#{ @subject().workflowId() }/classifications"
  
  toJSON: ->
    json =
      classification:
        subject_ids: [@subject().id]
    
    json.classification = $.extend json.classification, super
    delete json.classification.subject_id
    json
  
  send: ->
    Api.post @url(), @toJSON()

module.exports = Classification
