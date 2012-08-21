Spine = require 'spine'

class Papers extends Spine.Controller
  constructor: ->
    super
  
  active: ->
    super
    @render()
  
  render: ->
    @html require('views/papers')(@)

module.exports = Papers
