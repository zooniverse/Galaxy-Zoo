Spine = require 'spine'
UserGroup = require 'models/user_group'
User = require 'zooniverse/lib/models/user'

class Group extends Spine.Controller
  constructor: ->
    super
    @headingText = $("#heading_text")
    UserGroup.bind 'create', @displayElements

    UserGroup.bind 'invited', (result) =>
      unless _.isEmpty(result.rejected_invites)
        message = I18n.t('navigator.groups.invited_users') + 
          I18n.t('navigator.groups.rejected') + 
          result.rejected_invites.join ', '
        @usersInvited.text message
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
      @submitButton.text I18n.t('navigator.groups.create_button')
      @signUpForm.show()
      @inviteForm.show()
      @classFollowupQuestion.hide()
      @classFollowupQuestionOpen.hide()
      @noClassroom.hide()
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
      @submitButton.removeAttr 'disabled'
      @leaveGroupButton.hide()
      @destroyGroupButton.show()
      @inviteForm.show()
      @usersInvited.hide()
      @signUpForm.hide()
      @participation.show()
      url = "http://www.galaxyzoo.org/#/user_groups/#{group.unique_name}"
      @groupUrlHref.attr 'href', url
      @groupUrlHref.html url
      @groupUrl.show()
    if @group.id is User.current?.user_group_id
      @participateButton.hide()
      @stopParticipateButton.show()

  elements:
    'div#classroom' : 'classroomQuestion'
    'div#classroom-followup' : 'classFollowupQuestion'
    'label#classroom-followup-open' : 'classFollowupQuestionOpen'
    'div#no-classroom-followup' : 'noClassroom'
    'div.statistics' : 'statistics'
    'div.participation' : 'participation'
    'ul.stats' : 'statsView'
    'form#group-create' : 'signUpForm'
    'form#group-invite' : 'inviteForm'
    '#group-invite p.group-invites' : 'usersInvited'
    'input[name="name"]' : 'groupNameBox'
    'textarea[name="emails"]' : 'emails'
    'button[name="submit"]' : 'submitButton'
    'button[name="leave"]' : 'leaveGroupButton'
    'button[name="destroy"]' : 'destroyGroupButton'
    'button[name="yes"]' : 'participateButton'
    'button[name="no"]' : 'stopParticipateButton'
    'input[name="talk-flag"]' : 'hideTalk'
    'label.talk-flag' : 'talkLabel'
    'p.group-url' : 'groupUrl'
    'a.group-url-href' : 'groupUrlHref'

  events: 
    'click button[name="download"]' : 'downloadClassList'
    'click button[name="yes"]' : 'setParticipate'
    'click button[name="no"]'  : 'redirectHome'
    'click button[name="leave"]' : 'leaveGroup'
    'click button[name="destroy"]' : 'destroyGroup'
    'click input[name="classroom"]' : 'followupQuestion'
    'click #classroom' : 'disableSubmit'
    'click #no-classroom-followup' : 'enableSubmit'
    'click #classroom-followup' : 'enableSubmit'
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

  followupQuestion: (e) =>
    @classroomAnswer = e.currentTarget.value 
    if @classroomAnswer is 'yes'
      @classFollowupQuestion.show()
      @classFollowupQuestionOpen.show()
      @noClassroom.hide()
    else
      @noClassroom.show()
      @classFollowupQuestion.hide()
      @classFollowupQuestionOpen.hide()

  getSurveyAnswers: =>
    answers =
      hide_talk: @hideTalk.is ':checked'
      classroom: @classroomAnswer
      open: true

    if @classroomAnswer is 'yes'
      for school in ['elementary', 'middle', 'secondary', 'college', 'other']
        answers[school] = @$("""input[name="#{school}"]""").is ':checked'
      answers.other_elaborate = @$('input[name="elaborate-class"]').val() if answers.other is true
      answers.usage = @$('textarea[name="followup"]').val()
    else
      answers.individual = @$('input[name="alone"]').is ':checked'
      answers.group = @$('input[name="group"]').is ':checked'
      answers.group_elaborate = @$('input[name="elaborate-no-class"]').val() if answers.group is true
    answers

  enableSubmit: (e) =>
    @submitButton.removeAttr 'disabled'

  disableSubmit: (e) =>
    @submitButton.attr 'disabled', 'disabled'

  onSubmit: (e) =>
    e.preventDefault()
    @usersInvited.text I18n.t 'navigator.groups.invited_users'
    @submitButton.attr 'disabled', 'disabled'
    name = @groupNameBox.val()
    emails = @emails.val()
    metadata = @getSurveyAnswers()

    unless emails is ""
      if emails.search(", ") isnt -1
        emails = emails.split ', '
      else
        emails = emails.split ','

      if @groupId
        UserGroup.inviteUsers @groupId, emails unless _.isEmpty emails
      else
        newGroup = UserGroup.newGroup name, metadata
        newGroup.onSuccess (result) ->
          UserGroup.inviteUsers result.id, emails unless _.isEmpty emails
    else if not @groupId
      UserGroup.newGroup name, metadata
    else
      @submitButton.removeAttr 'disabled'
      
  downloadClassList: =>
    list = _(@group.users).chain().values().value()
    $.ajax
      type: 'POST'
      data: JSON.stringify(list)
      url: "https://jcvd.herokuapp.com/to-csv"
      crossDomain: true
      dataType: 'json'
      contentType: 'application/json'
      success: @downloadIframe

  downloadIframe: (data) =>
    $("body").append("""<iframe src="https://jcvd.herokuapp.com/to-csv/#{data.data_url}" style="display: none;"></iframe>""")

module.exports = Group
