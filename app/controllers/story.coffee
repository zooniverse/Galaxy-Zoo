Spine = require 'spine'

class Story extends Spine.Controller
  constructor: ->
    super
  
  active: ->
    super
    @render()
  
  render: ->
    @html require('views/story')(@)

module.exports = Story
