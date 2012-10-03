Spine = require('spine')
Navigator = require 'controllers/interactive/navigator'

class Interactive extends Spine.Controller

  constructor: ->
    super
    @html require('views/interactive/box')()

  active: =>
    super
    unless @navigator
      @navigator = new Navigator

    
module.exports = Interactive