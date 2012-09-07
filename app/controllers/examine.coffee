Spine = require 'spine'
Subject = require 'models/subject'
Api = require 'zooniverse/lib/api'
FITSViewer = require 'controllers/fitsviewer'
WebGL = require('lib/WebGL')

class Examine extends Spine.Controller
  events: 
    'click #load-fits': 'loadFits'
  
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
  
  loadFits: =>
    return unless @checkBrowserFeatures()
    if $('#dataonwire')[0]
      @requestFITS()
    else
      fitsFrame = $('<iframe id="dataonwire" src="http://www.sdss.org.uk/dr9zoo/fitsframe.html" style="display: none;"></iframe>')
      fitsFrame.on 'load', @requestFITS
      $('body').append fitsFrame
  
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
      @viewer.addImage(band, e.data.arraybuffer)
    
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
