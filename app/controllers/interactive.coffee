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
      if @group
        @setGroup @group

  elements:
    'select.groups-dropdown' : 'groupsDropdown'

  events: 
    'click a.show-groups' : 'showGroups'
    'change select.groups-dropdown' : 'goToGroup'

  activeGroups: =>
    if User.current and User.current.user_groups
      @groupsList = ['<option val="">Select Group</option>']
      for group in User.current.user_groups when group.id isnt @group?.id
        listItem = """<option value="#{group.id}">#{@formatGroupName(group.name)}</option>"""
        @groupsList.push listItem
      @groupsList.push '<option value="group">Make a New Group</option>'
    @appendGroups()

  setGroup: (group) =>
    @group = group
    @groupsDropdown.val group.id
    @activeGroups()

  showGroups: (e) =>
    e.preventDefault()
    @groupsDropdown.toggleClass "show-dropdown"

  appendGroups: =>
    @groupsDropdown.html @groupsList.join('\n')

  reset: =>
    @currentGroup.html 'Select Group'
    @activeGroups()

  goToGroup: (e) =>
    groupId = @el.find(e.currentTarget).val()
    if groupId is 'group'
      @navigate '/navigator/group/'
    else if groupId isnt ''
      @navigate "/navigator/group/#{groupId}"

  formatGroupName: (name) =>
    groupName = name.slice(0, 25)
    groupName = groupName + '...' if groupName isnt name
    return groupName

    
module.exports = Interactive