Spine = require('spine')
User = require 'zooniverse/lib/models/user'
UserGroup = require 'models/user_group'
LoginForm = require 'zooniverse/lib/controllers/login_form'
Home = require 'controllers/interactive/interactive'
MyGalaxies = require 'controllers/interactive/my_galaxies'
Group = require 'controllers/interactive/group'
Graph = require 'controllers/interactive/graphs'

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

  active: (params) =>
    super
    @page = params.page or 'home'
    @options = params.options
    @render()

  render: =>
    return unless @isActive()
    @view.release() if @currentView
    if User.current
      @html require('views/interactive/box')(@)
      @appendGroups()
      if @group or User.current.user_group_id
        @setGroup @group
      else
        @linkButtons.hide()
      @renderSubView()
    else
      @html require('views/login')()
      new LoginForm el: '#login'

  renderSubView: =>
    if @page is 'home'
      @view = new Home { el: '#navigator' }
    if @page is 'my_galaxies'
      @view = new MyGalaxies { el: '#navigator' }
    if @page is 'graphs'
      graph = @options or 'histogram'
      @view = new Graph { el: '#navigator', graphType: graph }
    if @page is 'group'
      id = @options or null
      @view = new Group { el: '#navigator', groupId: id }
    @view.render()

  elements:
    'select.groups-dropdown' : 'groupsDropdown'
    '#link_buttons' : 'linkButtons'

  events: 
    'click select.groups-dropdown option' : 'goToGroup'
    'change select.groups-dropdown' : 'goToGroup'

  activeGroups: =>
    @groupsList = ['<option val="">Select Group</option>']
    if User.current and User.current.user_groups
      for group in User.current.user_groups
        listItem = """<option value="#{group.id}">#{@formatGroupName(group.name, group.id)}</option>"""
        @groupsList.push listItem
    @groupsList.push '<option value="group">Make a New Group</option>'
    @appendGroups()

  setGroup: (group) =>
    @group = group
    @activeGroups()
    @groupsDropdown.val @group?.id or User.current.user_group_id

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
    @linkButtons.hide()
    @activeGroups()

  goToGroup: (e) =>
    groupId = @el.find(e.currentTarget).val()
    if groupId is 'group'
      @navigate '/navigator/group/'
    else if groupId isnt 'Select Group'
      @navigate "/navigator/group/#{groupId}"

  formatGroupName: (name, id) =>
    groupName = name.slice(0, 25)
    groupName = groupName + '...' if groupName isnt name
    groupName = '*' + groupName if id is @group?.id
    return groupName

    
module.exports = Interactive