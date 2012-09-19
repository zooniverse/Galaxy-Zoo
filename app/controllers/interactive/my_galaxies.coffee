Spine = require('spine')

class MyGalaxies extends Spine.Controller

  constructor: ->
    super

  active: ->
    super
    @render()
    $('[data-link="my_galaxies"]').addClass 'active'

  deactivate: ->
    $('[data-link="my_galaxies"]').removeClass 'active'
    @el.removeClass("active")

  render: ->
    @html require('views/interactive/my_galaxies')(@)    

module.exports = MyGalaxies