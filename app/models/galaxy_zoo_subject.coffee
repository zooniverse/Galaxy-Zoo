Spine = require 'spine'
Subject = require 'zooniverse/lib/models/subject'
SloanTree = require 'lib/sloan_tree'
CandelsTree = require 'lib/candels_tree'

class GalaxyZooSubject extends Subject
  @configure 'GalaxyZooSubject', 'zooniverse_id', 'coords', 'location', 'metadata'
  projectName: 'galaxy_zoo'
  
  trees:
    sloan: SloanTree
    candels: CandelsTree
  
  tree: -> @trees[@metadata.survey]
  image: -> @location.standard
  thumbnail: -> @location.thumbnail

module.exports = GalaxyZooSubject
