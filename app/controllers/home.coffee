Spine = require 'spine'
Recent = require 'models/project_recent'
Api = require 'zooniverse/lib/api'

class Home extends Spine.Controller
  
  constructor: ->
    super
    @html require 'views/home'

module.exports = Home
