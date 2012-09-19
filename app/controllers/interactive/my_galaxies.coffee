Spine = require('spine')

class MyGalaxies extends Spine.Controller

  constructor: ->
    super
    @action_title = '<h2>My Galaxies</h2>'

  active: ->
    super
    @render()
    $('[data-link="my_galaxies"]').addClass 'active'

  deactivate: ->
    @el.removeClass 'active'
    $('[data-link="my_galaxies"]').removeClass 'active'

  render: ->
    @html require('views/interactive/my_galaxies')(@)    

module.exports = MyGalaxies