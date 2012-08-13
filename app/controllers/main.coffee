Spine = require 'spine'
Home = require 'controllers/home'
Classify = require 'controllers/classify'
Science = require 'controllers/science'
Profile = require 'controllers/profile'

class Main extends Spine.Stack
  el: '#main'
  
  controllers:
    home: Home
    classify: Classify
    science: Science
    profile: Profile
  
  default: 'home'
  
  routes:
    '/': 'home'
    '/classify': 'classify'
    '/science': 'science'
    '/profile': 'profile'

module.exports = Main
