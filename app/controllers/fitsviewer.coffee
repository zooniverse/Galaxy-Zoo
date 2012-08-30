FITS  = require('fits')
WebGL = require('lib/WebGL')
Workers = require('lib/workers')

class FITSViewer extends Spine.Controller
  @bins = 500
  
  constructor: ->
    super
    
    # For inline workers
    window.URL = window.URL or window.webkitURL
    
    @images = {}
    @histograms = {}
    @means = {}
    @stds = {}
    
    @container = $("#examine .subject")
    @createBandButtons()
    
  
  createBandButtons: ->
    for band in @bands
      $("#examine .content-block").append("<button id='band-#{band}' class='band' disabled='disabled'>#{band}</button>")
  
  addImage: (obj) ->
    band = obj.band
    @images[band] = new FITS.File(obj.arraybuffer)
    
    # Select the dataunit
    dataunit = @images[band].getDataUnit()
    
    # Interpret the bytes and compute min and max
    # TODO: Ship off to inline worker
    dataunit.getFrame()
    dataunit.getExtremes()
    
    @setupHistogram(band)
    
    
  # Compute histogram using inline worker
  setupHistogram: (band) ->
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
    ), false
    worker.postMessage(msg)
    
    console.log @histograms, @means, @stds
    
module.exports = FITSViewer