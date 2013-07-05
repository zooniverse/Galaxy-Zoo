Config = require 'lib/config'
Api = require 'zooniverse/lib/api'
BaseSubject = require 'zooniverse/lib/models/subject'
SurveyGroup = require 'models/survey_group'
# SloanTree = require 'lib/sloan_tree'
# CandelsTree = require 'lib/candels_tree'
MinitProjectTree = require 'lib/mini_project_tree'

class Subject extends BaseSubject
  @configure 'Subject', 'zooniverse_id', 'coords', 'location', 'metadata'
  projectName: 'galaxy_zoo_starburst'
  
  surveys:
    # sloan:
    #   id: Config.surveys.sloan.id
    #   workflowId: Config.surveys.sloan.workflowId
    #   tree: MinitProjectTree
    # candels:
    #   id: Config.surveys.candels.id
    #   workflowId: Config.surveys.candels.workflowId
    #   tree: CandelsTree
    mini_project:
      id: "51d46e4b0374f5b13f000003"
      tree: MinitProjectTree
 
  @url: (params) -> @withParams "/projects/galaxy_zoo_starburst/groups/51d6ded30374f5c802000003/subjects", params
  # @randomSurveyId: -> @::surveys.sloan.id
  
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
    count = Config.subjectCache - @count()
    super.onSuccess =>
      @fetch() if count > 1
  
  @show: (id) ->
    Api.get "/projects/galaxy_zoo_starburst/subjects/#{ id }"
  
  constructor: ->
    super
    img = new Image
    img.src = @image()
  
  survey: -> @surveys.mini_project
  surveyId: -> "51d46e4b0374f5b13f000003"
  tree: -> @survey().tree
  workflowId: -> @survey().workflowId
  image: -> @location.standard
  thumbnail: -> @location.thumbnail

module.exports = Subject
