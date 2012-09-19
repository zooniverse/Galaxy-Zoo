Spine = require('spine')
Navigator = require 'controllers/interactive/navigator'

class Interactive extends Spine.Controller

  constructor: ->
    super
    box = require('views/interactive/box')()
    @html box

  active: =>
    super
    @navigator = new Navigator

    
module.exports = Interactive