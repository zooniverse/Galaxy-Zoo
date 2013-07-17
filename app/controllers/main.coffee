Spine = require 'spine'
Home = require 'controllers/home'
Classify = require 'controllers/classify'
Science = require 'controllers/science'
Profile = require 'controllers/profile'
Examine = require 'controllers/examine'
Papers = require 'controllers/papers'
Project = require 'controllers/project'
Team = require 'controllers/team'
Interactive = require 'controllers/interactive'
Astronomers = require 'controllers/astronomers'
UserGroups = require 'controllers/user_groups'

class Main extends Spine.Stack
  el: '#main'
  
  controllers:
    home: Home
    classify: Classify
    science: Science
    profile: Profile
    examine: Examine
    papers: Papers
    project: Project
    team: Team
    interactive: Interactive
    astronomers: Astronomers
    user_groups: UserGroups
    
  default: 'home'
  
  routes:
    '/': 'home'
    '/classify': 'classify'
    '/science': 'science'
    '/profile': 'profile'
    '/examine/:id': 'examine'
    '/papers': 'papers'
    '/project': 'project'
    '/team': 'team'
    '/navigator/:page': 'interactive'
    '/navigator/:page/:options': 'interactive'
    '/astronomers': 'astronomers'
    '/user_groups/:id': 'user_groups'

module.exports = Main
