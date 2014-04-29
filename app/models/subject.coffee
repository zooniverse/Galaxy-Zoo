Config = require 'lib/config'
Api = require 'zooniverse/lib/api'
BaseSubject = require 'zooniverse/lib/models/subject'
SurveyGroup = require 'models/survey_group'
SloanTree = require 'lib/sloan_tree'
CandelsTree = require 'lib/candels_tree'
UkidssTree = require 'lib/ukidss_tree'
FerengiTree = require 'lib/ferengi_tree'
UserGroup = require 'models/user_group'

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
    ukidss:
      id: Config.surveys.ukidss.id
      workflowId: Config.surveys.ukidss.workflowId
      tree: UkidssTree
    ferengi:
      id: Config.surveys.ferengi.id
      workflowId: Config.surveys.ferengi.workflowId
      tree: FerengiTree
  
  @url: (params) -> @withParams "/projects/galaxy_zoo/groups/#{ params.surveyId }/subjects", limit: params.limit
  @randomSurveyId: ->
    @::surveys.sloan.id
    # return @::surveys.sloan.id if UserGroup.current
    # n = Math.random()
    # if n <= 0.10
    #   @::surveys.sloan.id   # 10%
    # else
    #   @::surveys.ukidss.id  # 90%
  
  @next: ->
    if @current
      @current.destroy()
      @current = @first()
      @fetch() if @count() is 1
    else
      @fetch()
  
  @fetch: ->
    count = Config.subjectCache - @count()
    idCounts = { }
    idCounts[@::surveys.sloan.id] = 0
    idCounts[@::surveys.candels.id] = 0
    idCounts[@::surveys.ukidss.id] = 0
    idCounts[@::surveys.ferengi.id] = 0
    idCounts[@randomSurveyId()] += 1 for i in [1..count]
    
    hasTriggered = false
    for id, limit of idCounts
      continue if limit is 0
      Api.get @url(surveyId: id, limit: limit), (results) =>
        @create result for result in results
        @current or= @first()
        
        if @current and not hasTriggered
          hasTriggered = true
          @trigger 'fetched'

  # @fetch: ->
  #   hasTriggered = false
  #   Api.get @url(surveyId: @::surveys.sloan.id, limit: Config.subjectCache - @count()), (results) =>
  #     @create result for result in results
  #     @current or= @first()
  #     @trigger 'fetched' unless hasTriggered
  
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
