Group = require 'zooniverse/lib/models/group'
Config = require 'lib/config'

class GalaxyZooSurveyGroup extends Group
  @configure 'GalaxyZooSurveyGroup'
  projectName: 'galaxy_zoo'
  type: 'survey'
  
  @show(Config.surveys.sloan.id).always (group) => @sloan = @create group
  @show(Config.surveys.candels.id).always (group) => @candels = @create group

module.exports = GalaxyZooSurveyGroup
