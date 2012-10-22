Spine = require('spine')
User = require 'zooniverse/lib/models/user'
UserGroup = require 'models/user_group'
LoginForm = require 'zooniverse/lib/controllers/login_form'
Home = ->
MyGalaxies = ->
Group = ->
Graph = ->

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
    unless @navigatorLoaded
      $.getScript '/navigator.js', =>
        Home = require 'controllers/interactive/interactive'
        MyGalaxies = require 'controllers/interactive/my_galaxies'
        Group = require 'controllers/interactive/group'
        Graph = require 'controllers/interactive/graphs'
        @navigatorLoaded = true
        @initPage(params)
    else
      @initPage(params)

  initPage: (params) =>
    @page = params.page or 'home'
    @options = params.options
    @render()

  render: =>
    return unless @isActive()
    @view.release() if @currentView
    if User.current
      @html require('views/interactive/box')(@)
      @appendGroups()
      if @group 
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
    'ul.selection-dropdown' : 'groupsDropdown'
    '#link_buttons' : 'linkButtons'
    'a.current-selection' : 'currentSelection'

  events: 
    'click ul.selection-dropdown a' : 'toggleDropdown'
    'click a.open-dropdown' : 'toggleDropdown'

  activeGroups: =>
    @groupsList = new Array
    if User.current and User.current.user_groups
      for group in User.current.user_groups when @group?.id isnt group.id
        listItem = """<li><a href="/#/navigator/group/#{group.id}">#{@formatGroupName(group.name, group.id)}</a></li>"""
        @groupsList.push listItem
    @groupsList.push '<li><a href="/#/navigator/group/">Make a New Group</a></li>'
    @appendGroups()

  setGroup: (group) =>
    @group = group
    @currentSelection.text @formatGroupName(group.name, group.id)
    @currentSelection.attr 'href', "/#/navigator/group/#{group.id}"
    @linkButtons.show()
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
    delete @group
    @currentSelection.text 'Select Group'
    @currentSelection.removeAttr 'href'
    @linkButtons.hide()
    @activeGroups()

  formatGroupName: (name, id) =>
    groupName = name.slice(0, 20)
    groupName = groupName + '...' if groupName isnt name
    return groupName

  toggleDropdown: =>
    @groupsDropdown.toggleClass 'show-dropdown'

    
module.exports = Interactive