Group = require 'zooniverse/lib/models/group'
Config = require 'lib/config'

class SurveyGroup extends Group
  @configure 'SurveyGroup'
  projectName: 'galaxy_zoo_starburst'
  type: 'survey'
  
  @show(Config.surveys.sloan.id).always (group) => @sloan = @create group
  @show(Config.surveys.candels.id).always (group) => @candels = @create group

module.exports = SurveyGroup
