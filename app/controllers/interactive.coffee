Spine = require('spine')
Navigator = require 'controllers/interactive/navigator'
User = require 'zooniverse/lib/models/user'
UserGroup = require 'models/user_group'

class Interactive extends Spine.Controller

  constructor: ->
    super
    UserGroup.bind 'create', @displayGroups
    User.bind 'sign-in', @activeGroups

  active: =>
    super
    @activeGroups()
    @html require('views/interactive/box')(@)
    unless @navigator
      @navigator = new Navigator

  activeGroups: =>
    if User.current
      for key, value of User.current.project.groups
        if key isnt '50251c3b516bcb6ecb000001' or key isnt '50251c3b516bcb6ecb000002'
          UserGroup.fetch(key)

  displayGroups: (group) =>
    console.log group
    
module.exports = Interactive