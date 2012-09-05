Spine = require 'spine'
Subject = require 'models/subject'
Api = require 'zooniverse/lib/api'
FITSViewer = require 'controllers/fitsviewer'
WebGL = require('lib/WebGL')

class Examine extends Spine.Controller
  @validDestination = "http://www.sdss.org.uk/dr9zoo/"
  
  events: 
    "click #load-fits": "requestFITS"
  
  constructor: ->
    super
  
  active: (params) ->
    super
    @id = params.id
    @refresh()
    @render()
  
  deactivate: ->
    super
    @viewer.teardown() if @viewer?
  
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
    
    # # Testing FITS Frame with Portsmouth
    # window.addEventListener("message", @receiveFITS, false)
    # msg =
    #   location: '1237646588244590771'
    #   bands: ['u', 'g', 'r', 'i', 'z']
    # $("#dataonwire")[0].contentWindow.postMessage(msg, Examine.validDestination)
    
    # First check browser version
    unless @checkBrowserFeatures()
      alert('Upgrade your browser to use this feature.')
      return null
    
    # Deactive button
    $('#load-fits').attr("disabled", true)
    
    # Initialize new controller for viewer
    bands     = @subject.metadata.bands
    hubble_id = @subject.metadata.hubble_id # This should be more generic from Ouroboros.
    
    @viewer = new FITSViewer({el: $('#examine'), bands: bands})
    
    for band in bands
      do (band, hubble_id) =>
        # CORS BABY!
        url = "http://www.galaxyzoo.org.s3-website-us-east-1.amazonaws.com/subjects/raw/#{hubble_id}_#{band}.fits.fz"
        xhr = new XMLHttpRequest()
        xhr.open('GET', url)
        xhr.responseType = 'arraybuffer'
        xhr.onload = (e) =>
          @viewer.addImage(band, xhr.response)
        xhr.send()
  
  # receiveFITS: (e) =>
  #   console.log e

module.exports = Examine