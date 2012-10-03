Model = require 'zooniverse/lib/models/model'
User = require 'zooniverse/lib/models/user'
Api = require 'zooniverse/lib/api'

class UserGroup extends Model
  @configure 'UserGroup', 'name', 'owner', 'projects', 'users', 'user_ids', 'created_at', 'updated_at'
  
  @list: ->
    return unless User.current
    Api.get '/user_groups'
  
  @join: =>
    Api.post "/user_groups/#{ @currentId }/join", (json) =>
      @current = UserGroup.create json
  
  @participate: (id) =>
    Api.post "/user_groups/#{ id }/participate", (json) =>
      @currentId = id
      @current = UserGroup.create json
  
  @fetchCurrent: =>
    if User.current and User.current.user_group_id
      @participate User.current.user_group_id

module.exports = UserGroup
