Spine = require('spine')
Navigator = require 'controllers/interactive/navigator'
User = require 'zooniverse/lib/models/user'
UserGroup = require 'models/user_group'

class Interactive extends Spine.Controller

  constructor: ->
    super
    User.bind 'sign-in', @activeGroups

  active: =>
    super
    @html require('views/interactive/box')(@)
    unless @navigator
      @navigator = new Navigator

  activeGroups: =>
    @groups = new Array
    if User.current
      displayGroup group for group in User.current.user_groups



  displayGroup: (group) =>
    @groupsList.append
    
module.exports = Interactive