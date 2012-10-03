Spine = require 'spine'

class Astronomers extends Spine.Controller
  constructor: ->
    super
  
  active: ->
    super
    @render()
  
  render: ->
    @html require('views/astronomers')(@)

module.exports = Astronomers
