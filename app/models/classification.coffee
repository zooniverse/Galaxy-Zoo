Spine = require 'spine'
Annotation = require 'models/annotation'
GalaxyZooSubject = require 'models/galaxy_zoo_subject'

class Classification extends Spine.Model
  @configure 'Classification', 'subject_id', 'annotations'
  
  constructor: ->
    super
    @annotations = []
    @question = @subject().tree().first()
  
  subject: ->
    GalaxyZooSubject.find @subject_id

module.exports = Classification
