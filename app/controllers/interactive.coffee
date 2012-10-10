Spine = require('spine')
Navigator = require 'controllers/interactive/navigator'
User = require 'zooniverse/lib/models/user'
UserGroup = require 'models/user_group'
LoginForm = require 'zooniverse/lib/controllers/login_form'

class Interactive extends Spine.Controller

  constructor: ->
    super
    @groupsList = new Array
    User.bind 'sign-in', @render
    User.bind 'sign-in', @activeGroups
    UserGroup.bind 'participate', @setGroup
    UserGroup.bind 'stop', @reset
    UserGroup.bind 'create', @addGroup
    UserGroup.bind 'destroy-group', @removeGroup

  render: =>
    return unless @isActive()
    if typeof(@navigator) is 'undefined' and User.current
      @appendGroups()
      @html require('views/interactive/box')(@)
      @navigator = new Navigator
      if @group
        @setGroup @group
    else
      @navigator = undefined
      @html require('views/login')()
      new LoginForm el: '#login'

  elements:
    'select.groups-dropdown' : 'groupsDropdown'

  events: 
    'change select.groups-dropdown' : 'goToGroup'

  activeGroups: =>
    @groupsList = ['<option val="">Select Group</option>']
    if User.current and User.current.user_groups
      for group in User.current.user_groups
        listItem = """<option value="#{group.id}">#{@formatGroupName(group.name)}</option>"""
        @groupsList.push listItem
    @groupsList.push '<option value="group">Make a New Group</option>'
    @appendGroups()

  setGroup: (group) =>
    @group = group
    @groupsDropdown.val group.id
    @activeGroups()

  addGroup: (group) =>
    if typeof(User.current.user_groups) is 'undefined'
      User.current['user_groups'] = new Array
    item = _.find(User.current?.user_groups, (user_group) -> group.id is user_group.id)
    unless item
      User.current.user_groups.push { id: group.id, name: group.name }
    @activeGroups()

  removeGroup: (id) =>
    item = _.find(User.current.user_groups, (group) -> group.id is id)
    index = _.indexOf(User.current.user_groups, item)
    User.current.user_groups.splice(index, 1)
    @activeGroups()

  appendGroups: =>
    @groupsDropdown.html @groupsList.join('\n')

  reset: =>
    @groupsDropdown.val 'Select Group'
    @activeGroups()

  goToGroup: (e) =>
    groupId = @el.find(e.currentTarget).val()
    if groupId is 'group'
      @navigate '/navigator/group/'
    else if groupId isnt 'Select Group'
      @navigate "/navigator/group/#{groupId}"

  formatGroupName: (name) =>
    groupName = name.slice(0, 25)
    groupName = groupName + '...' if groupName isnt name
    return groupName

    
module.exports = Interactive