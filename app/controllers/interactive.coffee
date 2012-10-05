Spine = require('spine')
Navigator = require 'controllers/interactive/navigator'
User = require 'zooniverse/lib/models/user'
UserGroup = require 'models/user_group'

class Interactive extends Spine.Controller

  constructor: ->
    super
    @groupsList = new Array
    User.bind 'sign-in', @activeGroups unless User.current
    UserGroup.bind 'participate', @setGroup
    UserGroup.bind 'stop', @reset

  active: =>
    super
    unless @navigator
      @html require('views/interactive/box')(@)
      @appendGroups()
      @navigator = new Navigator

  elements:
    'ul.groups-dropdown' : 'groupsDropdown'
    'span.current-group' : 'currentGroup'

  events: 
    'click a.show-groups' : 'showGroups'

  activeGroups: =>
    if typeof(@currentGroupId) is 'undefined'
      @currentGroupId = User.current?.user_group_id
    if User.current and User.current.user_groups
      @groupsList = new Array
      for group in User.current.user_groups when group.id isnt @currentGroupId
        listItem = """<li class="user-group"><a href="/#/navigator/group/#{group.id}">#{@formatGroupName(group.name)}</a></li>"""
        @groupsList.push listItem
      @groupsList.push '<li><a href="/#/navigator/create_group">Make a New Group</a></li>'
    @appendGroups()

  setGroup: (group) =>
    @currentGroupId = group.id
    @currentGroup.html """<a href="/#/navigator/group/#{group.id}">#{@formatGroupName(group.name)}</a>"""    
    @activeGroups()

  showGroups: (e) =>
    e.preventDefault()
    @groupsDropdown.toggleClass "show-dropdown"

  appendGroups: =>
    @groupsDropdown.html @groupsList.join('\n')

  reset: =>
    @currentGroup.html '<a href="/#/navigator/create_group">Make a New Group</a>'
    @activeGroups()

  formatGroupName: (name) =>
    groupName = name.slice(0, 17)
    groupName = groupName + '...' if groupName isnt name
    return groupName

    
module.exports = Interactive