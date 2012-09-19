Spine = require 'spine'
MyGalaxies = require 'controllers/interactive/my_galaxies'
Home = require 'controllers/interactive/interactive'
ScatterplotPage = require 'controllers/interactive/scatterplot_page'
HistogramPage = require 'controllers/interactive/histogram_page'

class Navigator extends Spine.Stack
  el: '#navigator'

  controllers:
    myGalaxies: MyGalaxies
    scatterplotPage: ScatterplotPage
    histogramPage: HistogramPage
    home: Home

  default: 'home'

  routes: 
    '/navigator' : 'home'
    '/navigator/scatterplot' : 'scatterplotPage'
    '/navigator/histogram'   : 'histogramPage'
    '/navigator/my_galaxies' : 'myGalaxies'

module.exports = Navigator
