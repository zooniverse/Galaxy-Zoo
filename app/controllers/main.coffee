Spine = require 'spine'
Home = require 'controllers/home'
Classify = require 'controllers/classify'
Science = require 'controllers/science'
Profile = require 'controllers/profile'
Examine = require 'controllers/examine'
Papers = require 'controllers/papers'
Story = require 'controllers/story'
Team = require 'controllers/team'
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
    story: Story
    team: Team
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
    '/story': 'story'
    '/team': 'team'
    '/astronomers': 'astronomers'
    '/user_groups/:id': 'user_groups'

module.exports = Main
