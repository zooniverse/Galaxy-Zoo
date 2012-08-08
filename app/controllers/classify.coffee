Spine = require 'spine'
GalaxyZooSubject = require 'models/galaxy_zoo_subject'
Classification = require 'models/classification'

class Classify extends Spine.Controller
  constructor: ->
    super
    # TO-DO: Replace with a real subject manager
    @subject = GalaxyZooSubject.create
      id: '4fff2d0fc4039a09f10003e0'
      zooniverse_id: 'AGZ0123456'
      coords: [1, 2]
      location:
        standard: '/images/spiral_galaxy.jpeg'
        thumbnail: '/images/spiral_galaxy.jpeg'
      metadata:
        survey: 'sloan'
    
    @classification = Classification.create subject_id: @subject.id
  
  active: ->
    super
    @render()
  
  render: ->
    @html require('views/classify')(@)

module.exports = Classify
