Spine = require 'spine'
Recent = require 'models/project_recent'

class Home extends Spine.Controller
  elements:
    '.recents': 'recentsContainer'
  
  constructor: ->
    super
    @recents or= []
  
  active: ->
    super
    @updateRecents()
    @render()
  
  updateRecents: =>
    return unless @isActive()
    Recent.fetch(3).onSuccess (subjects) =>
      @recents = Recent.all()
      @recentsContainer.html require('views/recents')(@recents)
  
  render: ->
    @html require('views/home')(@)

module.exports = Home
