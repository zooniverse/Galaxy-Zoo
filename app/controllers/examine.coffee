Spine = require 'spine'
Subject = require 'models/subject'
Api = require 'zooniverse/lib/api'
FITSViewer = require 'controllers/fitsviewer'
WebGL = require 'lib/WebGL'

class Examine extends Spine.Controller
  events: 
    'click #load-fits': 'requestFITS'
  
  constructor: ->
    super
  
  active: (params) ->
    super
    @id = params.id
    @refresh()
    @render()
  
  deactivate: ->
    super
    @viewer?.teardown()
  
  refresh: =>
    return unless @isActive() and @id
    fetcher = Subject.show @id
    fetcher.onSuccess (json) => @subject = new Subject(json)
    fetcher.onSuccess @render
  
  render: =>
    @html require('views/examine/examine')(@)
  
  info: (key, values...) =>
    value = values.shift()
    return unless value
    
    """
      <div class="row">
        <span class="key">#{ key }:</span>
        <span class="value">#{ value } #{ values.join(' ') }</span>
      </div>
    """
  
  checkBrowserFeatures: =>
    checkDataView = DataView?
    checkWorker = Worker?
    checkWebGL = WebGL.check()
    checkDataView and checkWorker and checkWebGL
  
  requestFITS: =>
    return unless @checkBrowserFeatures()
    $('#load-fits').attr 'disabled', true
    
    bands = @subject.metadata.bands
    surveyId = @subject.surveyId()
    @viewer = new FITSViewer el: $('#examine'), bands: bands
    
    for band in bands
      do (band, surveyId) =>
        url = "http://www.galaxyzoo.org.s3-website-us-east-1.amazonaws.com/subjects/raw/#{ surveyId }_#{ band }.fits.fz"
        xhr = new XMLHttpRequest()
        xhr.open 'GET', url
        xhr.responseType = 'arraybuffer'
        xhr.onload = (e) =>
          @viewer.addImage band, xhr.response
        xhr.send()

module.exports = Examine
