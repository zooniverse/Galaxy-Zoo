Spine = require 'spine'
UserGroup = require 'models/user_group'
User = require 'zooniverse/lib/models/user'

class Group extends Spine.Controller
  constructor: ->
    super
    @headingText = $("#heading_text")
    UserGroup.bind 'create', (group) =>
      @group = group
      if @group.owner.id is User.current?.id
        @leaveGroupButton.hide()
        @destroyGroupButton.show()
        @groupStats()
        @signUpForm.show()

    UserGroup.bind 'invited', (result) =>
      if @group.id is result.id
        UserGroup.create result
        @emails.val('')
        @submitButton.removeAttr 'disabled'

    UserGroup.bind 'participate', =>
      @participateButton.hide()
      @stopParticipateButton.show()

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
        @group = UserGroup.current
        @groupStats()
        @participateButton.hide()
        @stopParticipateButton.show()
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

  elements:
    'div.stats' : 'statistics'
    'div.participation' : 'participation'
    'ul.stats' : 'statsView'
    'form#group-signup' : 'signUpForm'
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
      for key, user of @group.users when user.state is 'active'
        items.push """<li id="#{user.id}"><span class="name">#{user.name}</span><span class="count">#{user.classification_count}</span></li>"""
      @statsView.append items.join('\n')

  setParticipate: (e) =>
    e.preventDefault()
    UserGroup.participate @groupId
    @navigate '/navigator/home'

  redirectHome: (e) =>
    e.preventDefault()
    UserGroup.stop()
    @navigate '/navigator/home'

  leaveGroup: (e) =>
    e.preventDefault()
    UserGroup.leave @groupId
    @navigate '/navigator/home'

  destroyGroup: (e) =>
    e.preventDefault()
    UserGroup.delete @groupId
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
