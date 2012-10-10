Spine = require 'spine'
Home = require 'controllers/home'
Classify = require 'controllers/classify'
Science = require 'controllers/science'
Profile = require 'controllers/profile'
Examine = require 'controllers/examine'
Papers = require 'controllers/papers'
Story = require 'controllers/story'
Team = require 'controllers/team'
Interactive = require 'controllers/interactive'
Astronomers = require 'controllers/astronomers'
UserGroups = require 'controllers/user_groups'
Quizzer = require 'controllers/quizzer'

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
    interactive: Interactive
    astronomers: Astronomers
    user_groups: UserGroups
    quizzer: Quizzer
    
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
    '/navigator/:page': 'interactive'
    '/navigator/:page/:options': 'interactive'
    '/astronomers': 'astronomers'
    '/user_groups/:id': 'user_groups'
    '/quiz': 'quizzer'

module.exports = Main
