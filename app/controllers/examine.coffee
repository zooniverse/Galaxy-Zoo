Spine = require 'spine'
Subject = require 'models/subject'
Api = require 'zooniverse/lib/api'
FITSViewer = require 'controllers/fitsviewer'
WebGL = require('lib/web_gl')

class Examine extends Spine.Controller
  @validDestination = "http://www.sdss.org.uk/"
  
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
  
  # TODO: Move this into Zooniverse library
  checkBrowserFeatures: =>
    checkDataView = DataView?
    checkWorker = Worker?
    checkWebGL = WebGL.check()
    checkDataView and checkWorker and checkWebGL
  
  requestFITS: =>
    
    # First check browser version
    unless @checkBrowserFeatures()
      alert('Upgrade your browser to use this feature.')
      return null
    
    # Deactive button
    $('#load-fits').attr("disabled", true)
    console.log @subject
    
    id      = @subject.metadata.sdss_id or @subject.metadata.hubble_id
    survey  = @subject.metadata.survey
    
    # Initialize viewer
    @viewer = new FITSViewer({el: $('#examine'), bands: bands})
    
    # Request from Portsmouth
    console.log 'requesting FITS from Portsmouth'
    
    window.addEventListener("message", @receiveFITS, false)
    msg =
      survey: survey
      id: id
    $("#dataonwire")[0].contentWindow.postMessage(msg, Examine.validDestination)
  
  sexagesimal: =>
    [ra, dec] = @subject.coords
    return [@ddmmss(ra), @ddmmss(dec)]
  
  ddmmss: (degree) =>
    dd = Math.floor(degree)
    mantissa = degree - dd
    mmtmp = 60 * mantissa
    mm = Math.floor(mmtmp)
    mantissa = mmtmp - mm
    ss = (60 * mantissa).toFixed(3)
    
    return "#{dd}&deg; #{mm}' #{ss}\""
  
  receiveFITS: (e) =>
    if e.data.error?
      alert("Sorry, these data are not yet available.")
      window.removeEventListener("message", @receiveFITS, false)
    else
      data = e.data
      @viewer.addImage(data.band, data.arraybuffer)

module.exports = Examine
