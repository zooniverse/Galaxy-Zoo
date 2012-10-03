Spine = require 'spine'
MyGalaxies = require 'controllers/interactive/my_galaxies'
Home = require 'controllers/interactive/interactive'
Graphs = require 'controllers/interactive/graphs'
GroupCreate = require 'controllers/interactive/group_create'

class Navigator extends Spine.Stack
  el: '#navigator'

  controllers:
    myGalaxies: MyGalaxies
    graphs: Graphs
    home: Home
    groupCreate: GroupCreate

  default: 'home'

  routes: 
    '/navigator/home'               : 'home'
    '/navigator/graphs/:graphType'  : 'graphs'
    '/navigator/graphs'             : 'graphs'
    '/navigator/my_galaxies'        : 'myGalaxies'
    '/navigator/create_group'       : 'groupCreate'

module.exports = Navigator
