Spine = require('spine')

class Graph extends Spine.Controller

  events:
    'click .my_galaxies': 'linkToMyGalaxies'
    'click .graph': 'linkToGraph'

  constructor: ->
    super

  active: ->
    super
    @render()

  render: ->
    @html require('views/interactive/graph')(@)    

  linkToMyGalaxies: (ev) ->
    @navigate '/navigator/my_galaxies'
    ev.preventDefault()

  linkToGraph: (ev) ->
    @navigate '/navigator/graph'
    ev.preventDefault()

module.exports = Graph