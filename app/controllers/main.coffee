Spine = require 'spine'
Home = require 'controllers/home'
Classify = require 'controllers/classify'
Science = require 'controllers/science'
Profile = require 'controllers/profile'
Papers = require 'controllers/papers'
Story = require 'controllers/story'

class Main extends Spine.Stack
  el: '#main'
  
  controllers:
    home: Home
    classify: Classify
    science: Science
    profile: Profile
    papers: Papers
    story: Story
      
  default: 'home'
  
  routes:
    '/': 'home'
    '/classify': 'classify'
    '/science': 'science'
    '/profile': 'profile'
    '/papers': 'papers'
    '/story': 'story'

module.exports = Main
