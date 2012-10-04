Spine = require 'spine'
UserGroup = require 'models/user_group'

class GroupCreate extends Spine.Controller
  constructor: ->
    super
    @headingText = $("#heading_text")

  active: ->
    super
    @headingText.html '<h2>Create New Group</h2>'
    @render()

  elements:
    'input[name="name"]' : 'groupName'
    'textarea[name="emails"]' : 'emails'

  events:
    submit: 'onSubmit'

  render: =>
    @html require('views/interactive/group_create')(@)

  onSubmit: (e) =>
    e.preventDefault()
    name = @groupName.val()
    emails = @emails.val()

    if emails.search(", ") isnt -1
      emails = emails.split ', '
    else
      emails = emails.split ','

    console.log name, emails

    newGroup = UserGroup.newGroup name
    newGroup.onSuccess (result) ->
      UserGroup.inviteUsers result.id, emails

module.exports = GroupCreate
