Api = require 'zooniverse/lib/api'
Spine = require 'spine'

class UserGroup extends Spine.Model
  @configure 'created_at', 'name', 'owner', 'projects', 'users'

  @fetch: (id) =>
    fetcher = Api.get "projects/galaxy_zoo/user_groups/#{ id }", @createGroup
    fetcher

  @createGroup: (result) =>
    User.create
      created_at: result.created_at
      name: result.name
      owner: result.owner
      projects: result.projects
      users: result.users

module.exports = UserGroup    

    
