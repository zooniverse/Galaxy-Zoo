Model = require 'zooniverse/lib/models/model'
User = require 'zooniverse/lib/models/user'
Api = require 'zooniverse/lib/api'

class UserGroup extends Model
  @configure 'UserGroup', 'name', 'owner', 'projects', 'users', 'user_ids', 'created_at', 'updated_at', 'metadata', 'unique_name'
  
  @list: ->
    return unless User.current
    Api.getJSON '/user_groups'
  
  @join: =>
    Api.getJSON "/user_groups/#{@currentId}/join", (json) =>
      @current = UserGroup.create json
      @trigger 'participate', @current
  
  @stop: =>
    req = Api.getJSON "/user_groups/0/participate"
    req.always =>
      UserGroup.trigger 'stop', @current.id
      delete @current
  
  @participate: (id) =>
    Api.getJSON "/user_groups/#{ id }/participate", (json) =>
      @currentId = id
      @current = UserGroup.create json
      UserGroup.trigger 'participate', @current
  
  @fetchCurrent: =>
    if User.current and User.current.user_group_id
      @participate User.current.user_group_id
  
  @fetch: (id) =>
    Api.getJSON "/user_groups/#{ id }", (json) =>
      UserGroup.create json
  
  @newGroup: (name, metadata) =>
    json =
      user_group:
        name: name
        metadata: metadata
    
    Api.getJSON "/user_groups/create", json, (json) =>
      @current = UserGroup.create json
  
  @inviteUsers: (id, emails) =>
    json =
      user_emails: emails
    Api.getJSON "/user_groups/#{ id }/invite", json, (result) =>
      @trigger 'invited', result

  @leave: (id) =>
    Api.getJSON "/user_groups/#{ id }/leave", (result) =>
      @trigger 'destroy-group', result
      if @current?.id is id
        @current.destory()

  @delete: (id) =>
    req = Api.getJSON "/user_groups/#{ id }/destroy"
    req.always =>
      @trigger 'destroy-group', id
      if @current?.id is id
        @current.destroy()

module.exports = UserGroup
