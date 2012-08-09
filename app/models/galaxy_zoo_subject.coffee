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
  
  tree: -> @surveys[@metadata.survey].tree
  image: -> @location.standard
  thumbnail: -> @location.thumbnail

module.exports = GalaxyZooSubject
