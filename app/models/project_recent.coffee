Model = require 'zooniverse/lib/models/model'
Subject = require 'models/subject'
Api = require 'zooniverse/lib/api'

class ProjectRecent extends Model
  @configure 'ProjectRecent', 'project_id', 'workflow_id', 'subjects', 'created_at'

  @url: (params) -> @withParams "/projects/galaxy_zoo/recents", params
  
  @fetch: (count = 3) ->
    Api.get @url(per_page: count), (results) =>
      @destroyAll()
      @create result for result in results
  
  subject: -> @subjects[0]
  image: -> @subject().location.standard
  thumbnail: -> @subject().location.thumbnail

module.exports = ProjectRecent
