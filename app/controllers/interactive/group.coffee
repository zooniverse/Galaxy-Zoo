Spine = require 'spine'
UserGroup = require 'models/user_group'
User = require 'zooniverse/lib/models/user'

class Group extends Spine.Controller
  constructor: ->
    super
    @headingText = $("#heading_text")
    UserGroup.bind 'create', @displayElements

    UserGroup.bind 'invited', (result) =>
      if @group.id is result.id
        UserGroup.create result
        @emails.val('')
        @submitButton.removeAttr 'disabled'
        @usersInvited.show()

    UserGroup.bind 'participate', =>
      console.log 'here'
      @participateButton.hide()
      @stopParticipateButton.show()

    UserGroup.bind 'stop', =>
      console.log 'here'
      @participateButton.show()
      @stopParticipateButton.hide()

  active: (params) =>
    super
    @render()
    @groupId = null
    @groupName = null
    console.log params
    if params.id isnt ''
      unless User.current
        return
      @groupId = params.id
      @groupName = (_.find(User.current.user_groups, (group) =>
        group.id is @groupId)).name
      @headingText.html "<h2>#{@groupName}</h2>"

      if @groupId and @groupId is UserGroup.current?.id
        @displayElements(UserGroup.current)
      else
        UserGroup.fetch(@groupId)
    else
      @headingText.html '<h2>Create New Group</h2>'
      @signUpForm.show()
      @groupNameBox.show()
      @participation.hide()
      @statistics.hide()

  deactivate: =>
    super
    if @group
      @group.destroy() unless UserGroup.current?.id is @group.id

  render: =>
    @html require('views/interactive/participate')(@)

  displayElements: (group) =>
    @group = group
    if @group.owner.id is User.current?.id
      @leaveGroupButton.hide()
      @destroyGroupButton.show()
      @groupStats()
      @signUpForm.show()
      @statistics.show()
    if @group.id is User.current?.user_group_id
      @participateButton.hide()
      @stopParticipateButton.show()

  elements:
    'div.stats' : 'statistics'
    'div.participation' : 'participation'
    'ul.stats' : 'statsView'
    'form#group-signup' : 'signUpForm'
    '#group-signup p' : 'usersInvited'
    'input[name="name"]' : 'groupNameBox'
    'textarea[name="emails"]' : 'emails'
    'button[name="submit"]' : 'submitButton'
    'button[name="leave"]' : 'leaveGroupButton'
    'button[name="destroy"]' : 'destroyGroupButton'
    'button[name="yes"]' : 'participateButton'
    'button[name="no"]' : 'stopParticipateButton'

  events: 
    'click button[name="yes"]' : 'setParticipate'
    'click button[name="no"]'  : 'redirectHome'
    'click button[name="leave"]' : 'leaveGroup'
    'click button[name="destroy"]' : 'destroyGroup'
    submit: 'onSubmit'

  groupStats: =>
    if (@groupId is @group.id) and (User.current.id is @group.owner.id)
      items = new Array
      for key, user of @group.users
        count = if user.state is 'active' then user.classification_count else user.state
        items.push """<li id="#{user.id}"><span class="name">#{user.name}</span><span class="count">#{count}</span></li>"""
      @statsView.append items.join('\n')

  setParticipate: (e) =>
    e.preventDefault()
    UserGroup.participate @groupId
    User.current['user_group_id'] = @groupId

  redirectHome: (e) =>
    e.preventDefault()
    UserGroup.stop()
    delete User.current.user_group_id

  leaveGroup: (e) =>
    e.preventDefault()
    UserGroup.leave @groupId
    @navigate '/navigator/home'

  destroyGroup: (e) =>
    e.preventDefault()
    UserGroup.delete @groupId
    groupObj = { id: @group.id, name: @group.name }
    index = _.indexOf User.current?.user_groups, groupObj
    delete User.current.user_groups[index]
    @navigate '/navigator/home'

  onSubmit: (e) =>
    e.preventDefault()
    @submitButton.attr 'disabled', 'disabled'
    name = @groupNameBox.val()
    emails = @emails.val()

    if emails.search(", ") isnt -1
      emails = emails.split ', '
    else
      emails = emails.split ','

    if @groupId
      UserGroup.inviteUsers @groupId, emails
    else
      newGroup = UserGroup.newGroup name
      newGroup.onSuccess (result) ->
        UserGroup.inviteUsers result.id, emails
      
module.exports = Group
