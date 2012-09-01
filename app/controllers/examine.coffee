Spine = require 'spine'
Subject = require 'models/subject'
Api = require 'zooniverse/lib/api'
FITSViewer = require 'controllers/fitsviewer'
WebGL = require('lib/WebGL')

class Examine extends Spine.Controller
  @validDestination = "http://www.galaxyzoo.org.s3.amazonaws.com/"
  
  events: 
    "click #load-fits": "requestFITS"
  
  constructor: ->
    super
  
  active: (params) ->
    super
    @id = params.id
    @refresh()
    @render()
  
  refresh: =>
    return unless @isActive() and @id
    fetcher = Subject.show @id
    fetcher.onSuccess (json) => @subject = new Subject(json)
    fetcher.onSuccess @render
  
  render: =>
    console.log @subject
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
    checkWorker   = Worker?
    checkWebGL    = WebGL.check()
    
    return (checkDataView and checkWorker and checkWebGL)
  
  requestFITS: =>
    console.log 'requestFITS'
    
    # First check browser version
    unless @checkBrowserFeatures()
      alert('Upgrade your browser to use this feature.')
      return null
    
    # # Deactive button
    # $('#load-fits').attr("disabled", true)
    
    # Initialize new controller for viewer
    bands     = @subject.metadata.bands
    hubble_id = @subject.metadata.hubble_id # This should be more generic from Ouroboros.
    @viewer = new FITSViewer({el: $('#examine'), bands: bands})
    
    for band in bands
      do (band, hubble_id) =>
        # CORS BABY!
        url = "https://s3.amazonaws.com/www.galaxyzoo.org/subjects/raw/#{hubble_id}_#{band}.fits.fz"
        xhr = new XMLHttpRequest()
        xhr.open('GET', url)
        xhr.responseType = 'arraybuffer'
        xhr.onload = (e) =>
          @viewer.addImage(band, xhr.response)
        xhr.send()

module.exports = Examine