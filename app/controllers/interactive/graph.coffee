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

  linkToMyGalaxies: (e) ->
    @navigate '/navigator/my_galaxies'
    e.preventDefault()

  linkToGraph: (e) ->
    @navigate '/navigator/graph'
    e.preventDefault()

module.exports = Graph