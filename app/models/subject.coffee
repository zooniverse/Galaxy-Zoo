Config = require 'lib/config'
Api = require 'zooniverse/lib/api'
BaseSubject = require 'zooniverse/lib/models/subject'
SurveyGroup = require 'models/survey_group'
SloanTree = require 'lib/sloan_tree'
CandelsTree = require 'lib/candels_tree'
UkidssTree = require 'lib/ukidss_tree'
FerengiTree = require 'lib/ferengi_tree'
SloanSinglebandTree = require 'lib/sloan_singleband_tree'
GoodsTree = require 'lib/goods_full_tree'
DecalsTree = require 'lib/decals_tree'
IllustrisTree = require 'lib/illustris_tree'
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
    candels_2epoch:
      id: Config.surveys.candels_2epoch.id
      workflowId: Config.surveys.candels_2epoch.workflowId
      tree: CandelsTree
    goods_full:
      id: Config.surveys.goods_full.id
      workflowId: Config.surveys.goods_full.workflowId
      tree: GoodsTree
    sloan_singleband:
      id: Config.surveys.sloan_singleband.id
      workflowId: Config.surveys.sloan_singleband.workflowId
      tree: SloanSinglebandTree
    decals:
      id: Config.surveys.decals.id
      workflowId: Config.surveys.decals.workflowId
      tree: DecalsTree
    illustris:
      id: Config.surveys.illustris.id
      workflowId: Config.surveys.illustris.workflowId
      tree: IllustrisTree
  
  @url: (params) -> @withParams "/projects/galaxy_zoo/groups/#{ params.surveyId }/subjects", limit: params.limit

  @randomSurveyId: ->
    n = Math.random()
    if n <= 0.5
      @::surveys.decals.id
    else
      @::surveys.illustris.id

  @next: ->
    if @current
      @current.destroy()
      @current = @first()
      @fetch() if @count() is 1
    else
      @fetch()
  
  @fetch: ->
    count = Config.subjectCache - @count()
    idCounts = {}
    for i in [1..count]
      survey = @randomSurveyId()
      idCounts[survey] ||= 0
      idCounts[survey] += 1

    hasTriggered = false
    for id, limit of idCounts
      Api.get @url(surveyId: id, limit: limit), (results) =>
        @create result for result in results
        @current or= @first()
        
        if @current and not hasTriggered
          hasTriggered = true
          @trigger 'fetched'
  
  @show: (id) ->
    Api.get "/projects/galaxy_zoo/subjects/#{ id }"
  
  constructor: ->
    super
    img = new Image
    img.src = @image()
  
  survey: -> @surveys[@metadata.survey]
  surveyId: -> @metadata.provided_image_id
  tree: -> @survey().tree
  workflowId: -> @survey().workflowId
  image: -> @location.standard
  thumbnail: -> @location.thumbnail

  showInverted: ->
    if @metadata.survey == 'sloan_singleband'
      true
    else
      false

module.exports = Subject
