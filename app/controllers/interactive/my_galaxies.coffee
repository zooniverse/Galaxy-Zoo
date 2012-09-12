Spine = require('spine')

class MyGalaxies extends Spine.Controller

  events:
    'click .my_galaxies': 'linkToMyGalaxies'
    'click .graph': 'linkToGraph'

  constructor: ->
    super

  active: ->
    super
    @render()

  render: ->
    @html require('views/interactive/my_galaxies')(@)    

  linkToMyGalaxies: (ev) ->
    @navigate '/navigator/my_galaxies'
    ev.preventDefault()

  linkToGraph: (ev) ->
    @navigate '/navigator/graph'
    ev.preventDefault()

module.exports = MyGalaxies