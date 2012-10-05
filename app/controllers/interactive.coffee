Spine = require('spine')
Navigator = require 'controllers/interactive/navigator'
User = require 'zooniverse/lib/models/user'
UserGroup = require 'models/user_group'

class Interactive extends Spine.Controller

  constructor: ->
    super
    @groupsList = new Array
    User.bind 'sign-in', @activeGroups unless User.current
    UserGroup.bind 'create', @setGroup
    UserGroup.bind 'destory', @reset

  active: =>
    super
    console.log @navigator
    unless @navigator
      @html require('views/interactive/box')(@)
      @activeGroups()
      @navigator = new Navigator

  elements:
    'ul.groups-dropdown' : 'groupsDropdown'
    'span.current-group' : 'currentGroup'

  events: 
    'click a.show-groups' : 'showGroups'

  activeGroups: =>
    if User.current and User.current.user_groups
      for group in User.current.user_groups
        listItem = """<li class="user-group"><a href="/#/navigator/group/#{group.id}">#{group.name}</a></li>"""
        @groupsList.push listItem
      @appendGroups()

  setGroup: (group) =>
    @currentGroup.html """<a href="/#/navigator/group/#{group.id}">#{group.name}</a>"""    
    @groupsList.push '<li><a href="/#/navigator/create_group">Make a New Group</a></li>'
    @appendGroups()

  showGroups: (e) =>
    e.preventDefault()
    @groupsDropdown.toggleClass "show-dropdown"

  appendGroups: =>
    @groupsDropdown.html @groupsList.join('\n')

  reset: =>
    @currentGroup.html '<a href="/#/navigator/create_group">Make a New Group</a>'
    @activeGroups()
    
module.exports = Interactive