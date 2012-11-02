Config = require 'lib/config'
Api = require 'zooniverse/lib/api'
BaseSubject = require 'zooniverse/lib/models/subject'
SurveyGroup = require 'models/survey_group'
SloanTree = require 'lib/sloan_tree'
CandelsTree = require 'lib/candels_tree'

class Subject extends BaseSubject
  @configure 'Subject', 'zooniverse_id', 'coords', 'location', 'metadata'
  projectName: 'galaxy_zoo'
  
  surveys:
    sloan:
      id: Config.surveys.sloan.id
      workflowId: Config.surveys.sloan.workflowId
      tree: SloanTree
    candels:
      id: Config.surveys.candels.id
      workflowId: Config.surveys.candels.workflowId
      tree: CandelsTree
  
  @url: (params) -> @withParams "/projects/galaxy_zoo/groups/#{ @randomSurveyId() }/subjects", params
  @randomSurveyId: -> if Math.random() > 0.166667 then @::surveys.sloan.id else @::surveys.candels.id
  
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
    Api.get "/projects/galaxy_zoo/subjects/#{ id }"
  
  constructor: ->
    super
    img = new Image
    img.src = @image()
  
  survey: -> @surveys[@metadata.survey]
  surveyId: -> @metadata.hubble_id or @metadata.sdss_id
  tree: -> @survey().tree
  workflowId: -> @survey().workflowId
  image: -> @location.standard
  thumbnail: -> @location.thumbnail

module.exports = Subject
