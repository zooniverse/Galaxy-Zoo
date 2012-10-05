Spine = require 'spine'
UserGroup = require 'models/user_group'
User = require 'zooniverse/lib/models/user'

class Group extends Spine.Controller
  constructor: ->
    super
    @headingText = $("#heading_text")
    UserGroup.bind 'create', (group) =>
      @group = group
      @groupStats()

  active: (params) =>
    super
    unless User.current
      return
    @groupId = params.id
    @groupName = (_.find(User.current.user_groups, (group) =>
      group.id is @groupId)).name
    @headingText.html "<h2>#{@groupName}</h2>"
    @html require('views/interactive/participate')(@)

    if @groupId and @groupId is UserGroup.current?.id
      @group = UserGroup.current
      @groupStats()
    else
      UserGroup.fetch(@groupId)

  deactivate: =>
    super
    if @group
      @group.destroy() unless User.current?.user_group_id is @group.id

  events: 
    'click button[name="yes"]' : 'setParticipate'
    'click button[name="no"]'  : 'redirectHome'

  setParticipate: (e) =>
    e.preventDefault()
    UserGroup.participate @groupId
    @navigate '/navigator/home'

  redirectHome: (e) =>
    e?.preventDefault?()
    UserGroup.stop()
    @navigate '/navigator/home'

  groupStats: =>
    if (@groupId is @group.id) and (User.current.id is @group.owner.id)
      stats = new Object
      stats[user.name] = user.classification_count for key, user of @group.users
      @append require('views/interactive/stats')({stats})
    else
      @group.destroy()
      
module.exports = Group
