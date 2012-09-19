Spine = require('spine')

class MyGalaxies extends Spine.Controller

  constructor: ->
    super

  active: ->
    super
    @render()

  render: ->
    @html require('views/interactive/my_galaxies')(@)    

module.exports = MyGalaxies