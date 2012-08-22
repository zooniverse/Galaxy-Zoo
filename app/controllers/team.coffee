Spine = require 'spine'

class Team extends Spine.Controller
  constructor: ->
    super
  
  active: ->
    super
    @render()
  
  render: ->
    @html require('views/team')(@)

module.exports = Team
