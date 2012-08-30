FITS  = require('fits')
WebGL = require('lib/WebGL')
Workers = require('lib/workers')

class FITSViewer extends Spine.Controller
  @bins = 500
  
  events:
    "click .band": "selectBand"
    "change #stretch": "selectStretch"
  
  constructor: ->
    super
    
    # For inline workers
    window.URL = window.URL or window.webkitURL
    
    # Storage for data
    @images = {}
    @histograms = {}
    @means = {}
    @stds = {}
    
    # Parent container for WebGL context
    @container = document.querySelector("#examine .subject")
    
    # Setup UI
    @controls = $("#viewer-controls")
    @controls.empty()
    @createBandButtons()
    @createStretchButtons()
    
    @setupWebGL()
    
    
  createBandButtons: =>
    for band in @bands
      @controls.append("<button id='band-#{band}' class='band' value='#{band}' disabled='disabled'>#{band}</button>")
  
  createStretchButtons: =>
    @controls.append("<select id='stretch'>
                        <option value='linear'>Linear</option>
                        <option value='logarithm'>Logarithm</option>
                        <option value='sqrt'>Square Root</option>
                        <option value='arcsinh'>Arcsinh</option>
                        <option value='power'>Power</option>
                      </select>")
    @stretch = $("#stretch")
  
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
    
    # Storing one WebGL program per filter.  There are better ways to do this, especially in GLSL 4.0.
    @programs = {}
    for func in ['linear', 'logarithm', 'sqrt', 'arcsinh', 'power']
      fragmentShader  = WebGL.loadShader(@gl, WebGL.fragmentShaders[func], @gl.FRAGMENT_SHADER)
      @programs[func] = WebGL.createProgram(@gl, [@vertexShader, fragmentShader])
    
    stretch = @stretch.val()
    @program = @programs[stretch]
    @gl.useProgram(@program)
    
    # Locations of WebGL program variables
    positionLocation    = @gl.getAttribLocation(@program, 'a_position')
    resolutionLocation  = @gl.getUniformLocation(@program, 'u_resolution')
    extremesLocation    = @gl.getUniformLocation(@program, 'u_extremes')
    
    # Send the resolutionLocation and extremeLocation values to program
    @gl.uniform2f(resolutionLocation, @width, @height)
    
    
    
  selectBand: (e) =>
    console.log e.currentTarget.value
    
  selectStretch: (e) =>
    console.log e.currentTarget.value
    
module.exports = FITSViewer