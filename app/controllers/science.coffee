Spine = require 'spine'

class Science extends Spine.Controller
  constructor: ->
    super
  
  active: ->
    super
    @render()
  
  render: ->
    @html require('views/science')(@)

module.exports = Science
