Spine = require 'spine'
Home = require 'controllers/home'
Classify = require 'controllers/classify'
Science = require 'controllers/science'
Profile = require 'controllers/profile'
Examine = require 'controllers/examine'
Papers = require 'controllers/papers'
Story = require 'controllers/story'
Team = require 'controllers/team'
Interactive = require 'controllers/interactive/interactive'
ChooseInvestigation = require 'controllers/interactive/choose_investigation'
MyGalaxies = require 'controllers/interactive/my_galaxies'
Graph = require 'controllers/interactive/graph'

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
    choose_investigation: ChooseInvestigation 
    my_galaxies: MyGalaxies
    graph: Graph
      
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
    '/navigator': 'interactive'
    '/navigator/choose_investigation': 'choose_investigation'
    '/navigator/my_galaxies': 'my_galaxies'
    '/navigator/graph': 'graph'

module.exports = Main
