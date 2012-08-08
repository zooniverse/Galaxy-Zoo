Spine = require 'spine'

class Classify extends Spine.Controller
  constructor: ->
    super
  
  active: ->
    super
    @render()
  
  render: ->
    @html require('views/classify')(@)

module.exports = Classify
