Config = require 'lib/config'
Subject = require 'zooniverse/lib/models/subject'
GalaxyZooSurveyGroup = require 'models/galaxy_zoo_survey_group'
SloanTree = require 'lib/sloan_tree'
CandelsTree = require 'lib/candels_tree'

class GalaxyZooSubject extends Subject
  @configure 'GalaxyZooSubject', 'zooniverse_id', 'coords', 'location', 'metadata'
  projectName: 'galaxy_zoo'
  
  surveys:
    sloan:
      id: Config.surveys.sloan
      tree: SloanTree
    candels:
      id: Config.surveys.candels
      tree: CandelsTree
  
  @url: (params) -> @withParams "/projects/galaxy_zoo/groups/#{ @randomSurveyId() }/subjects", params
  @randomSurveyId: -> if Math.random() > 0.5 then @::surveys.sloan.id else @::surveys.candels.id
  
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
    super count
  
  constructor: ->
    super
    img = new Image
    img.src = @image()
  
  tree: -> @surveys[@metadata.survey].tree
  image: -> @location.standard
  thumbnail: -> @location.thumbnail

module.exports = GalaxyZooSubject
