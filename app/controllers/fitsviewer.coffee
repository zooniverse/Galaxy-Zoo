FITS  = require('fits')
WebGL = require('lib/WebGL')
Workers = require('lib/workers')

class FITSViewer extends Spine.Controller
  @bins = 500
  
  events:
    "click .band": "selectBand"
  
  constructor: ->
    super
    
    # For inline workers
    window.URL = window.URL or window.webkitURL
    
    @images = {}
    @histograms = {}
    @means = {}
    @stds = {}
    
    @container = document.querySelector("#examine .subject")
    @createBandButtons()
    @setupWebGL()
    
  createBandButtons: ->
    for band in @bands
      $("#examine .content-block").append("<button id='band-#{band}' class='band' value='#{band}' disabled='disabled'>#{band}</button>")
  
  addImage: (obj) ->
    band = obj.band
    @images[band] = new FITS.File(obj.arraybuffer)
    
    # Select the dataunit
    dataunit = @images[band].getDataUnit()
    
    # Interpret the bytes and compute min and max
    # TODO: Ship off to inline worker
    dataunit.getFrame()
    dataunit.getExtremes()
    
    @computeStatistics(band)
    
  # Compute histogram using inline worker
  computeStatistics: (band) ->
    dataunit = @images[band].getDataUnit()
    
    # Set up message to pass to worker
    msg =
      min: dataunit.min
      max: dataunit.max
      data: dataunit.data
      bins: FITSViewer.bins
      band: band
    
    # Inline baby!!
    blob = new Blob([Workers.Histogram])
    blobUrl = window.URL.createObjectURL(blob)
    
    worker = new Worker(blobUrl)
    worker.addEventListener 'message', ((e) =>
      data = e.data
      band = data.band
      @histograms[band] = data.histogram
      @means[band]      = data.mean
      @stds[band]       = data.std
      
      # Enable associated button
      $("#band-#{band}").removeAttr('disabled')
      
    ), false
    worker.postMessage(msg)
  
  setupWebGL: =>
    # TODO: Set this dynamically
    [@width, @height] = [424, 424]
    canvas  = WebGL.setupCanvas(@container, @width, @height)
    @gl     = WebGL.create3DContext(canvas)
    @ext    = @gl.getExtension('OES_texture_float')
    
    unless @ext
      alert "No OES_texture_float"
      return null
    
    @vertexShader = WebGL.loadShader(@gl, WebGL.vertexShader, @gl.VERTEX_SHADER)
    
  selectBand: (e) =>
    console.log e.currentTarget.value
    
module.exports = FITSViewer