Config = require 'lib/config'
Api = require 'zooniverse/lib/api'
BaseSubject = require 'zooniverse/lib/models/subject'
SurveyGroup = require 'models/survey_group'
SloanTree = require 'lib/sloan_tree'
CandelsTree = require 'lib/candels_tree'
UkidssTree = require 'lib/ukidss_tree'

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
  
  @url: (params) -> @withParams "/projects/galaxy_zoo/groups/#{ params.surveyId }/subjects", limit: params.limit
  @randomSurveyId: ->
    return @::surveys.ukidss.id
    if Math.random() > 0.5
      @::surveys.ukidss.id
    else
      if Math.random() > (1/3) then @::surveys.sloan.id else @::surveys.candels.id
  
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
    idCounts[@randomSurveyId()] += 1 for i in [1..count]
    
    hasTriggered = false
    for id, limit of idCounts
      continue if limit is 0
      Api.get @url(surveyId: id, limit: limit), (results) =>
        @create result for result in results
        @current or= @first()
        
        unless hasTriggered
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
