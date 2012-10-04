Spine = require 'spine'
MyGalaxies = require 'controllers/interactive/my_galaxies'
Home = require 'controllers/interactive/interactive'
Graphs = require 'controllers/interactive/graphs'
GroupCreate = require 'controllers/interactive/group_create'
Group = require 'controllers/interactive/group'

class Navigator extends Spine.Stack
  el: '#navigator'

  controllers:
    myGalaxies: MyGalaxies
    graphs: Graphs
    home: Home
    groupCreate: GroupCreate
    group: Group

  default: 'home'

  routes: 
    '/navigator/home'               : 'home'
    '/navigator/graphs/:graphType'  : 'graphs'
    '/navigator/graphs'             : 'graphs'
    '/navigator/my_galaxies'        : 'myGalaxies'
    '/navigator/create_group'       : 'groupCreate'
    '/navigator/group/:id'          : 'group'

module.exports = Navigator
