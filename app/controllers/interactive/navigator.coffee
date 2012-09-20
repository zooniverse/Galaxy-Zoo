Spine = require 'spine'
MyGalaxies = require 'controllers/interactive/my_galaxies'
Home = require 'controllers/interactive/interactive'
Graphs = require 'controllers/interactive/graphs'
ScatterplotPage = require 'controllers/interactive/scatterplot_page'
HistogramPage = require 'controllers/interactive/histogram_page'

class Navigator extends Spine.Stack
  el: '#navigator'

  controllers:
    myGalaxies: MyGalaxies
    graphs: Graphs
    scatterplotPage: ScatterplotPage
    histogramPage: HistogramPage
    home: Home

  default: 'home'

  routes: 
    '/navigator/home'               : 'home'
    '/navigator/graphs/:graphType'  : 'graphs'
    '/navigator/graphs'             : 'graphs'
    '/navigator/my_galaxies'        : 'myGalaxies'

module.exports = Navigator
