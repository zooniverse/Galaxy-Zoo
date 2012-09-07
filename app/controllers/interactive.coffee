Spine = require('spine')

class Interactive extends Spine.Controller

  constructor: ->
    super
    box = require('views/interactive/box')
    @html box
    
module.exports = Interactive