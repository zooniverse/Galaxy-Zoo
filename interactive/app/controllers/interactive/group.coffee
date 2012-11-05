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
      @participateButton.hide()
      @stopParticipateButton.show()

    UserGroup.bind 'stop', =>
      @participateButton.show()
      @stopParticipateButton.hide()

  render: =>
    @html require('views/interactive/participate')(@)
    if @groupId
      if UserGroup.exists @groupId
        UserGroup.destroy(@groupId)
        UserGroup.fetch(@groupId)
      else
        UserGroup.fetch(@groupId)
    else
      @headingText.html "<h2>#{ I18n.t('navigator.groups.create') }</h2>"
      @signUpForm.show()
      @groupNameBox.show()
      @participation.hide()
      @statistics.hide()
      @talkLabel.show()

  displayElements: (group) =>
    @group = group
    @headingText.html "<h2>#{@group.name}</h2>"
    @groupStats()
    if @groupId is null
      @navigate "/navigator/group/#{ @group.id }"
    if @group.owner.id is User.current.id
      @leaveGroupButton.hide()
      @destroyGroupButton.show()
      @signUpForm.show()
      @usersInvited.hide()
      @groupNameBox.hide()
      @participation.show()
    if @group.id is User.current?.user_group_id
      @participateButton.hide()
      @stopParticipateButton.show()

  elements:
    'div.statistics' : 'statistics'
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
    'input[name="talk-flag"]' : 'hideTalk'
    'label.talk-flag' : 'talkLabel'

  events: 
    'click button[name="yes"]' : 'setParticipate'
    'click button[name="no"]'  : 'redirectHome'
    'click button[name="leave"]' : 'leaveGroup'
    'click button[name="destroy"]' : 'destroyGroup'
    submit: 'onSubmit'

  groupStats: =>
    items = new Array
    if (@groupId is @group.id) and (User.current.id is @group.owner.id)
      for key, user of @group.users
        items.push @statListItem user
    else
      user = _.find(@group.users, (user) -> user.id is User.current.id)
      items.push @statListItem user
    @statsView.append items.join('\n')

  statListItem: (user) ->
    count = if user.state is 'active' then user.classification_count else user.state
    """<li id="#{user.id}"><span class="name">#{user.name}</span><span class="count">#{count}</span></li>"""

  setParticipate: (e) =>
    e.preventDefault()
    UserGroup.participate @groupId
    User.current['user_group_id'] = @groupId
    @navigate '/classify'

  redirectHome: (e) =>
    e.preventDefault()
    UserGroup.stop()
    delete User.current.user_group_id

  leaveGroup: (e) =>
    answer = confirm I18n.t('navigator.groups.confirm_leave')
    return unless answer
    e.preventDefault()
    UserGroup.leave @groupId
    @navigate '/navigator/home'

  destroyGroup: (e) =>
    answer = confirm I18n.t('navigator.groups.confirm_destroy')
    return unless answer
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
    hideTalk = @hideTalk.is ':checked'

    if emails.search(", ") isnt -1
      emails = emails.split ', '
    else
      emails = emails.split ','

    if @groupId
      UserGroup.inviteUsers @groupId, emails
    else
      newGroup = UserGroup.newGroup name, hideTalk
      newGroup.onSuccess (result) ->
        UserGroup.inviteUsers result.id, emails
      
module.exports = Group
