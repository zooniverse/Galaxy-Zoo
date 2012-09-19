Spine = require('spine')
Scatterplot = require('ubret/lib/controllers/Scatterplot')

class Graph extends Spine.Controller

  constructor: ->
    super

  active: ->
    super
    @render()

  render: ->
    @html require('views/interactive/graph')(@)    

module.exports = Graph