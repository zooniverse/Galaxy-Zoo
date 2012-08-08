Spine = require 'spine'
Home = require 'controllers/home'
Classify = require 'controllers/classify'

class Main extends Spine.Stack
  el: '#main'
  
  controllers:
    home: Home
    classify: Classify
  
  default: 'home'
  
  routes:
    '/': 'home'
    '/classify': 'classify'

module.exports = Main
