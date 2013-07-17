Config = require 'lib/config'
Api = require 'zooniverse/lib/api'
BaseSubject = require 'zooniverse/lib/models/subject'
# SloanTree = require 'lib/sloan_tree'
# CandelsTree = require 'lib/candels_tree'
MiniProjectTree = require 'lib/mini_project_tree'

class Subject extends BaseSubject
  @configure 'Subject', 'zooniverse_id', 'coords', 'location', 'metadata'
  projectName: 'galaxy_zoo_starburst'
  
  surveys:
    mini_project:
      workflowId: '51e6fcdd3ae74023b9000002'
      tree: MiniProjectTree
 
  @url: (params) -> @withParams "/projects/galaxy_zoo_starburst/subjects", params
  
  @next: ->
    if @current
      @current.destroy()
      @current = @first()
      @fetch() if @count() is 1
    else
      @fetch().onSuccess =>
        @current = @first()
        @trigger 'fetched'
  
  @fetch: ->
    super Config.subjectCache - @count()
  
  @show: (id) ->
    Api.get "/projects/galaxy_zoo_starburst/subjects/#{ id }"
  
  constructor: ->
    super
    img = new Image
    img.src = @image()
  
  survey: -> @surveys.mini_project
  tree: -> @survey().tree
  workflowId: -> @survey().workflowId
  image: -> @location.standard
  thumbnail: -> @location.thumbnail

module.exports = Subject
