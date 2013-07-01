Spine = require 'spine'

class Project extends Spine.Controller
  constructor: ->
    super
  
  active: ->
    super
    @render()
  
  render: ->
    @html require('views/project')(@)

module.exports = Project
