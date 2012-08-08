Spine = require 'spine'
SloanTree = require 'lib/sloan_tree'
CandelsTree = require 'lib/candels_tree'

class Classify extends Spine.Controller
  constructor: ->
    super
  
  active: ->
    super
    @render()
  
  render: ->
    @html require('views/classify')(@)

module.exports = Classify
