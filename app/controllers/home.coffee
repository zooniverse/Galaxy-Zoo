Spine = require 'spine'

class Home extends Spine.Controller
  constructor: ->
    super
  
  active: ->
    super
    @render()
  
  render: ->
    @html require('views/home')(@)

module.exports = Home
