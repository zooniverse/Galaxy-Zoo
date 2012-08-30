Spine = require 'spine'
Subject = require 'models/subject'
Api = require 'zooniverse/lib/api'
FITSViewer = require 'controllers/fitsviewer'

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
  
  # TODO: Check for WebGL
  checkBrowserFeatures: =>
    checkDataView = DataView?
    checkWorker = Worker?
    return (checkDataView and checkWorker)
  
  requestFITS: =>
    console.log 'requestFITS'
    
    window.addEventListener("message", @receiveFITS, false)
    
    # First check browser version
    unless @checkBrowserFeatures()
      alert('Upgrade your browser to use this feature.')
      return null
    
    # # Deactive button
    # $('#load-fits').attr("disabled", true)
    
    # Initialize new controller for viewer
    @viewer = new FITSViewer({el: $('#examine')})
    
    # Send a message to iframe requesting data
    msg =
      location: @subject.location.raw
      bands: @subject.metadata.bands
    $("#dataonwire")[0].contentWindow.postMessage(msg, Examine.validDestination)
  
  receiveFITS: (e) =>
    @viewer.addImage(e.data)


module.exports = Examine