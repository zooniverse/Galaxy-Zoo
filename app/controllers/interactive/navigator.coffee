Spine = require 'spine'
MyGalaxies = require 'controllers/interactive/my_galaxies'
Home = require 'controllers/interactive/interactive'
Graphs = require 'controllers/interactive/graphs'

class Navigator extends Spine.Stack
  el: '#navigator'

  controllers:
    myGalaxies: MyGalaxies
    graphs: Graphs
    home: Home

  default: 'home'

  routes: 
    '/navigator/home'               : 'home'
    '/navigator/graphs/:graphType'  : 'graphs'
    '/navigator/graphs'             : 'graphs'
    '/navigator/my_galaxies'        : 'myGalaxies'

module.exports = Navigator
