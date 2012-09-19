Spine = require 'spine'
MyGalaxies = require 'controllers/interactive/my_galaxies'
Graph = require 'controllers/interactive/graph'
Home = require 'controllers/interactive/interactive'

class Navigator extends Spine.Stack
  el: '#navigator'

  controllers:
    myGalaxies: MyGalaxies
    graph: Graph
    home: Home

  default: 'home'

  routes: 
    '/navigator' : 'home'
    '/navigator/graph' : 'graph'
    '/navigator/my_galaxies' : 'myGalaxies'

module.exports = Navigator
