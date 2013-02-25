
# Troublesome
# #/examine/AGZ00013gv

class FITSViewer extends Spine.Controller
  validDestination: "http://www.sdss.org.uk/"
  viewportDimension: 424
  bins: 10000
  
  
  events:
    "click .band": "selectBand"
    "change #stretch": "selectStretch"
  
  
  constructor: ->
    super
    
    # Default stretch
    @stretch = 'linear'
    
    # Listen for when WebFITS Api is ready
    @bind('fitsviewer:ready', =>
      
      # Setup WebFITS context
      @wfits = new astro.WebFITS(@el.find('.subject')[0], @viewportDimension)
      @wfits.setupControls()
      
      # Request FITS images
      @requestFITS(@survey, @survey_id)
      @unbind('fitsviewer:ready')
    )
    
    # Request WebFITS
    @getApi()
    
    # Storage for data
    @histograms = {}
    @means = {}
    @percentiles = {}
  
  getApi: ->
    # Determine if WebGL is supported, otherwise fall back to canvas
    canvas  = document.createElement('canvas')
    context = canvas.getContext('webgl')
    context = canvas.getContext('experimental-webgl') unless context?

    # Load appropriate WebFITS library asynchronously
    lib = if context? then 'gl' else 'canvas'
    url = "/javascripts/webfits-#{lib}.js"
    $.getScript(url, =>
      @trigger 'fitsviewer:ready'
    )
  
  requestFITS: (survey, id) ->
    window.addEventListener("message", @receiveFITS, false)
    msg =
      survey: survey
      id: id
    $("#dataonwire")[0].contentWindow.postMessage(msg, @validDestination)
  
  receiveFITS: (e) =>
    if e.origin is 'https://api.zooniverse.org'
      return null
      
    # TODO: Error handling needs work.
    if e.data.error?
      window.removeEventListener("message", @receiveFITS, false)
    else
      data = e.data
      buffer = data.arraybuffer
      band = data.band
      
      f = new astro.FITS.File(buffer)
      dataunit = f.getDataUnit()
      arr = dataunit.getFrame()
      [min, max] = dataunit.getExtent(arr)
      
      @wfits.loadImage(band, arr, dataunit.width, dataunit.height)
      [histogram, mean, lower, upper] = computeStatistics(min, max, @bins, arr)
      @histograms[band] = histogram
      @means[band] = mean
      @percentiles[band] = [lower, upper]
      
      if @wfits.nImages is @bands.length
        
        # Stop listening after all images received
        window.removeEventListener("message", @receiveFITS, false)
        
        # Setup controls
        @controls = $("#viewer-controls")
        @createMetadata()
        @createBandButtons()
        @createStretchButtons()
        
        # Get global extent
        mins = []
        maxs = []
        for key, values of @percentiles
          mins.push values[0]
          maxs.push values[1]
        
        gMin = Math.min.apply(Math, mins)
        gMax = Math.max.apply(Math, maxs)
        
        # Set parameters for visualization
        @wfits.setExtent(gMin, gMax)
        @wfits.setImage(@bands[0])
  
  createMetadata: =>
    @subjectInfo = $("#examine .subject-info")
    @subjectInfo.append("""
      <div class='row'>
        <span class='key'>#{ I18n.t 'fits.x_y' }:</span>
        <span class='xy value'></span>
      </div>
    """)
    @subjectInfo.append("""
      <div class='row'>
        <span class='key'>#{ I18n.t 'fits.intensity' }:</span>
        <span class='intensity value'></span>
      </div>
    """)
    
  destroyMetadata: =>
    @subjectInfo.empty() if @subjectInfo
    @subjectInfo = null
  
  createBandButtons: =>
    for band in @bands
      bandLower = band.toLowerCase()
      @controls.append("<button id='band-#{band}' class='band' value='#{band}'>#{bandLower}</button>")
    @controls.append("<button id='band-color' class='band' value='color'>#{ I18n.t('fits.color') }</button>")
  
  destroyBandButtons: =>
    @controls.empty() if @controls
    @controls = null
  
  createStretchButtons: =>
    @controls.append("<select id='stretch'>
                        <option value='linear'>#{ I18n.t('fits.linear') }</option>
                        <option value='logarithm'>#{ I18n.t('fits.logarithm') }</option>
                        <option value='sqrt'>#{ I18n.t('fits.square_root') }</option>
                        <option value='arcsinh'>#{ I18n.t('fits.arcsinh') }</option>
                        <option value='power'>#{ I18n.t('fits.power') }</option>
                      </select>")
    @stretch = $("#stretch")
  
  destroyStretchButtons: =>
    @controls.empty() if @controls
  
  selectBand: (e) =>
    band = e.currentTarget.value
    if band is 'color'
      @el.find('.subject img').show()
    else
      @el.find('.subject img').hide()
      @wfits.setImage(band)
      @wfits.draw()
  
  selectStretch: (e) =>
    @stretch = e.currentTarget.value
    @wfits.setStretch(@stretch)
  
  computeStatistics = (min, max, bins, data) ->
    range = max - min
    binSize = range / bins
    numPixels = data.length
    numNaNs = 0
    sum = 0
    
    # Initialize array
    histogram = new Array(bins + 1)
    for value, index in histogram
      step = binSize * index
      histogram[index] = [step, 0]
      
    for value, index in data
      if isNaN(value)
        numNaNs += 1
        continue
      sum += value
      index = Math.floor(((value - min) / range) * bins)
      histogram[index][1] += 1
      
    mean = sum / (numPixels - numNaNs)
    
    # Recompute sum to be offset by min
    sum = 0
    sorted = [] # Push to JS array to use the default sort
    for value in data
      value -= min
      sum += value
      sorted.push value
    sorted = sorted.sort()
    
    # Compute percentiles
    [lower, upper] = [0.0025, 0.9975]
    
    running = 0
    for value, index in sorted
      running += value
      percentile = running / sum
      if percentile > lower
        lower = sorted[index - 1] + min
        break
        
    running = 0
    for value, index in sorted
      running += value
      percentile = running / sum
      if percentile > upper
        upper = sorted[index - 1] + min
        break
        
    return [histogram, mean, lower, upper]
  
  teardown: =>
    @destroyStretchButtons()
    @destroyBandButtons()
    @destroyMetadata()
    
    
module.exports = FITSViewer
