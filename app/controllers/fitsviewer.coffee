FITS  = require('fits')
WebGL = require('lib/WebGL')
Workers = require('lib/workers')

class FITSViewer extends Spine.Controller
  @bins = 500
  @viewportWidth  = 424
  @viewportHeight = 424
  
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
    
    # Store band and texture location
    @textureCount = 0
    @textures = {}
    
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
    @addTexture(band, dataunit.data)
    
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
  
  # Sets up everything except for textures
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
    
    # Storing one WebGL program per stretch function.  There are better ways to do this, especially in GLSL 4.0.
    @programs = {}
    for func in ['linear', 'logarithm', 'sqrt', 'arcsinh', 'power']
      fragmentShader  = WebGL.loadShader(@gl, WebGL.fragmentShaders[func], @gl.FRAGMENT_SHADER)
      @programs[func] = WebGL.createProgram(@gl, [@vertexShader, fragmentShader])
    
    stretch = @stretch.val()
    @program = @programs[stretch]
    @gl.useProgram(@program)
    
    # Grab locations of WebGL program variables
    positionLocation    = @gl.getAttribLocation(@program, 'a_position')
    texCoordLocation    = @gl.getAttribLocation(@program, 'a_textureCoord')
    extremesLocation    = @gl.getUniformLocation(@program, 'u_extremes')
    offsetLocation      = @gl.getUniformLocation(@program, 'u_offset')
    scaleLocation       = @gl.getUniformLocation(@program, 'u_scale')
    
    # Buffer for texture coordinates
    texCoordBuffer = @gl.createBuffer()
    @gl.bindBuffer(@gl.ARRAY_BUFFER, texCoordBuffer)
    @gl.bufferData(@gl.ARRAY_BUFFER, new Float32Array([0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0]), @gl.STATIC_DRAW)
    @gl.enableVertexAttribArray(texCoordLocation)
    @gl.vertexAttribPointer(texCoordLocation, 2, @gl.FLOAT, false, 0, 0)
    
    # Buffer for position
    buffer = @gl.createBuffer()
    @gl.bindBuffer(@gl.ARRAY_BUFFER, buffer)
    @gl.enableVertexAttribArray(positionLocation)
    @gl.vertexAttribPointer(positionLocation, 2, @gl.FLOAT, false, 0, 0)
    @setRectangle(0, 0, @width, @height)
    
    # Set the initial variables for panning and zooming
    @xOffset = -@width / 2
    @yOffset = -@height / 2
    @xOldOffset = @xOffset
    @yOldOffset = @yOffset
    @scale = 2 / @width
    @minScale = 1 / (FITSViewer.viewportWidth * FITSViewer.viewportWidth)
    @maxScale = 2
    @drag = false
  
  addTexture: (band, data) =>
    address = "TEXTURE#{@textureCount}"
    @gl.activeTexture(@gl[address])
    
    texture = @gl.createTexture()
    @gl.bindTexture(@gl.TEXTURE_2D, texture)
    @gl.texParameteri(@gl.TEXTURE_2D, @gl.TEXTURE_WRAP_S, @gl.CLAMP_TO_EDGE)
    @gl.texParameteri(@gl.TEXTURE_2D, @gl.TEXTURE_WRAP_T, @gl.CLAMP_TO_EDGE)
    @gl.texParameteri(@gl.TEXTURE_2D, @gl.TEXTURE_MIN_FILTER, @gl.NEAREST)
    @gl.texParameteri(@gl.TEXTURE_2D, @gl.TEXTURE_MAG_FILTER, @gl.NEAREST)
    @gl.texImage2D(@gl.TEXTURE_2D, 0, @gl.LUMINANCE, @width, @height, 0, @gl.LUMINANCE, @gl.FLOAT, data)
    
    @textures[band] = address
    @textureCount += 1
    
  setRectangle: (x, y, width, height) =>
    [x1, x2] = [x, x + width]
    [y1, y2] = [y, y + height]
    @gl.bufferData(@gl.ARRAY_BUFFER, new Float32Array([x1, y1, x2, y1, x1, y2, x1, y2, x2, y1, x2, y2]), @gl.STATIC_DRAW)

  drawScene: =>
    $("#examine .subject img").hide()
    
    offsetLocation = @gl.getUniformLocation(@program, 'u_offset')
    scaleLocation = @gl.getUniformLocation(@program, 'u_scale')
    @gl.uniform2f(offsetLocation, @xOffset, @yOffset)
    @gl.uniform1f(scaleLocation, @scale)
    @setRectangle(0, 0, @width, @height)
    @gl.drawArrays(@gl.TRIANGLES, 0, 6)  
  
  selectBand: (e) =>
    band = e.currentTarget.value
    
    # Get extremes
    dataunit  = @images[band].getDataUnit()
    minimum   = dataunit.min
    maximum   = dataunit.max
    
    extremesLocation = @gl.getUniformLocation(@program, 'u_extremes')
    @gl.uniform2f(extremesLocation, minimum, maximum)
    
    address = @textures[band]
    @gl.activeTexture(@gl[address])
    
    @drawScene()
    
  selectStretch: (e) =>
    stretch = e.currentTarget.value
    @program = @programs[stretch]
    @gl.useProgram(@program)
    
    @drawScene()
    
module.exports = FITSViewer