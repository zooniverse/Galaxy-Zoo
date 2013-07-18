Spine = require 'spine'
Recent = require 'models/project_recent'
Api = require 'zooniverse/lib/api'


class Home extends Spine.Controller
  elements:
    '.recents': 'recentsContainer'
  
  constructor: ->
    super
    @recents or= []
  
  active: ->
    super
    @updateRecents()

    project = Api.get "/projects/galaxy_zoo_starburst"

    project.onSuccess (data) =>
      $(".classification_count").html (data.classification_count*100.0/(6000.0*20.0)).toFixed(1)
    @render()
  
  updateRecents: =>
    return unless @isActive()
    return if @recentsFetcher
    @recentsFetcher = Recent.fetch(3).onSuccess (subjects) =>
      @recents = Recent.all()
      @recentsContainer.html require('views/recents')(@recents)
      @recentsFetcher = null
  
  render: ->
    @html require('views/home')(@)

module.exports = Home
