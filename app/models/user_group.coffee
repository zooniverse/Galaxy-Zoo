Spine = require 'spine'
Api = require 'zooniverse/lib/api'

class UserGroup extends Spine.Model
  @configure 'created_at', 'name', 'owner', 'projects', 'users'

  @fetch: (id) =>
    fetcher = Api.get "/user_groups/#{ id }", @createGroup
    fetcher

  @createGroup: (result) =>
    UserGroup.create
      created_at: result.created_at
      name: result.name
      owner: result.owner
      projects: result.projects
      users: result.users

  @newGroup: (name) =>
    json = 
      user_group: 
        name: name

    sender = Api.post "/user_groups", json, @createGroup
    sender

  @inviteUsers: (id, emails) =>
    json = 
      user_emails: emails
    sender = Api.post "/user_groups/#{ id }/invite", json
    sender

module.exports = UserGroup    

    
