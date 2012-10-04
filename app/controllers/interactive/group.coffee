Spine = require 'spine'
UserGroup = require 'models/user_group'
User = require 'zooniverse/lib/models/user'

class Group extends Spine.Controller
  constructor: ->
    super
    @headingText = $("#heading_text")
    UserGroup.bind 'create', @groupStats

  active: (params) =>
    super
    unless User.current
      return
    @groupId = params.id

    UserGroup.fetch(@groupId)
    @groupName = (_.find User.current.user_groups, (group) =>
      group.id = @groupId).name

    @headingText.html "<h2>#{@groupName}</h2>"

    @html require('views/interactive/participate')(@)

  events: 
    'click button[name="yes"]' : 'setParticipate'
    'click button[name="no"]'  : 'redirectHome'

  setParticipate: (e) =>
    e.preventDefault()
    UserGroup.participate @groupId
    @navigate '/classify'

  redirectHome: (e) =>
    e?.preventDefault?()
    UserGroup.stop()
    @navigate '/navigator/home'

  groupStats: (group) =>
    console.log group
    if (@groupId is group.id) and (User.current.id is group.owner.id)
      stats = new Object
      console.log user for key, user of group.users
      stats[user.name] = user.classification_count for key, user of group.users
      console.log stats
      @append require('views/interactive/stats')({stats})
    group.destroy()
      
module.exports = Group
