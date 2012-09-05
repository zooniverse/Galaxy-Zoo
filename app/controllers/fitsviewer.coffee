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
    @createMetadata()
    @createBandButtons()
    @createStretchButtons()
    
    @setupWebGL()
  
  createMetadata: =>
    @subjectInfo = $("#examine .subject-info")      
    @subjectInfo.append("""
      <div class='row'>
        <span class='key'>X, Y</span>
        <span class='value' id='xy'></span>
      </div>
    """)
    @subjectInfo.append("""
      <div class='row'>
        <span class='key'>Intensity</span>
        <span class='value' id='intensity'></span>
      </div>
    """)
    
  destroyMetadata: =>
    @subjectInfo.empty() if @subjectInfo
    @subjectInfo = null
  
  createBandButtons: =>
    for band in @bands
      bandUpper = band.toUpperCase()
      @controls.append("<button id='band-#{band}' class='band' value='#{band}' disabled='disabled'>#{bandUpper}</button>")
  
  destroyBandButtons: =>
    @controls.empty() if @controls
    @controls = null
  
  createStretchButtons: =>
    @controls.append("<select id='stretch'>
                        <option value='linear'>Linear</option>
                        <option value='logarithm'>Logarithm</option>
                        <option value='sqrt'>Square Root</option>
                        <option value='arcsinh'>Arcsinh</option>
                        <option value='power'>Power</option>
                      </select>")
    @stretch = $("#stretch")
  
  destroyStretchButtons: =>
    @controls.empty() if @controls
    @stretch = null
  
  addImage: (band, arraybuffer) ->
    @images[band] = new FITS.File(arraybuffer)
    
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
    @canvas = WebGL.setupCanvas(@container, @width, @height)
    @gl     = WebGL.create3DContext(@canvas)
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
    
    @canvas.onmousedown = (e) =>
      @drag = true
      
      @xOldOffset = @xOffset
      @yOldOffset = @yOffset
      @xMouseDown = e.clientX 
      @yMouseDown = e.clientY

    @canvas.onmouseup = (e) =>
      @drag = false
      
      # Prevents a NaN from being sent to the GPU
      return null unless @xMouseDown?
      
      xDelta = e.clientX - @xMouseDown
      yDelta = e.clientY - @yMouseDown
      @xOffset = @xOldOffset + (xDelta / @canvas.width / @scale * 2.0)
      @yOffset = @yOldOffset - (yDelta / @canvas.height / @scale * 2.0)
      @drawScene()
    
    @canvas.onmousemove = (e) =>
      xDelta = -1 * (@canvas.width / 2 - e.offsetX) / @canvas.width / @scale * 2.0
      yDelta = (@canvas.height / 2 - e.offsetY) / @canvas.height / @scale * 2.0
      
      x = ((-1 * (@xOffset + 0.5)) + xDelta) + 0.5 << 0
      y = ((-1 * (@yOffset + 0.5)) + yDelta) + 0.5 << 0
      
      # TODO: Write to screen
      $("#xy").html("#{x}, #{y}")
      if @band
        $("#intensity").html(@images[@band].getDataUnit().getPixel(x, y).toFixed(5))
      
      return unless @drag
      
      xDelta = e.clientX - @xMouseDown
      yDelta = e.clientY - @yMouseDown
      
      @xOffset = @xOldOffset + (xDelta / @canvas.width / @scale * 2.0)
      @yOffset = @yOldOffset - (yDelta / @canvas.height / @scale * 2.0)
      
      @drawScene()
    
    @canvas.onmouseout = (e) =>
      @drag = false
      
    @canvas.onmouseover = (e) =>
      @drag = false
    
    # Listen for the mouse wheel
    @canvas.addEventListener('mousewheel', @wheelHandler, false)
    @canvas.addEventListener('DOMMouseScroll', @wheelHandler, false)
  
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
    # TODO: Try to call this only once
    $("#examine .subject img").hide()
    
    # Get and set program locations
    offsetLocation    = @gl.getUniformLocation(@program, 'u_offset')
    scaleLocation     = @gl.getUniformLocation(@program, 'u_scale')
    extremesLocation  = @gl.getUniformLocation(@program, 'u_extremes')
    
    @gl.uniform2f(offsetLocation, @xOffset, @yOffset)
    @gl.uniform1f(scaleLocation, @scale)
    @gl.uniform2f(extremesLocation, @currentMin, @currentMax)
    
    @setRectangle(0, 0, @width, @height)
    @gl.drawArrays(@gl.TRIANGLES, 0, 6)  
  
  selectBand: (e) =>
    @band = e.currentTarget.value
    
    # Cache minimum and maximum values for selected band
    dataunit = @images[@band].getDataUnit()
    [@minimum, @maximum] = [@currentMin, @currentMax] = @getPercentiles(@band)
    
    # Select correct texture and draw
    address = @textures[@band]
    @gl.activeTexture(@gl[address])
    @drawScene()
    
    # Plot histogram and markers
    @histogram = $.plot($("#plots .histogram"), [{color: '#002332', data: @histograms[@band]}], FITSViewer.setHistogramOptions(@minimum, @maximum))
    @drawMarkers([@minimum, @maximum])
    
    # Set up slider
    do =>
      @slider = $(".slider")
      plotWidth   = @histogram.width()
      offsetLeft  = @histogram.getPlotOffset().left
      
      @slider.css('width', "#{plotWidth}px")
      @slider.css('margin-left', "#{offsetLeft}px")
      sliderOptions =
        range: true
        min: @minimum
        max: @maximum
        values: [@minimum, @maximum]
        step: (@maximum - @minimum) / 1000
        slide: (e, ui) =>
          values = ui.values
          [@currentMin, @currentMax] = values
          @drawMarkers(values)
          @drawScene()
      
      @slider.slider(sliderOptions)
  
  selectStretch: (e) =>
    stretch = e.currentTarget.value
    @program = @programs[stretch]
    @gl.useProgram(@program)
    
    @drawScene()

  wheelHandler: (e) =>
    e.preventDefault()
    e.stopPropagation()
    factor = if e.shiftKey then 1.01 else 1.1
    @scale *= if (e.detail or e.wheelDelta) < 0 then factor else 1 / factor

    # Probably not the most efficient way to do this ...
    @scale = if @scale > @maxScale then @maxScale else @scale
    @scale = if @scale < @minScale then @minScale else @scale
    @drawScene()
  
  # Set histogram options when a new image is selected
  @setHistogramOptions: (minimum, maximum) ->
    options =
      xaxis:
        min: minimum
        max: maximum
      lines:
        show: true
        fill: true
        fillColor: '#002332'
        lineWidth: 1
        
    return options
  
  getPercentiles: (band) =>
    [mean, std]  = [@means[band], @stds[band]]
    return [mean - 10 * std, mean + 10 * std]
  
  # Draws markers over the histogram
  drawMarkers: (values) =>
    offsets = @histogram.getPlotOffset()
    markerWidth = 0.002 * (@maximum - @minimum)
    options =
      grid:
        borderWidth: 0
        aboveData: true
        margin:
          left:   offsets.left
          right:  offsets.right
          top:    offsets.top
          bottom: offsets.bottom
        markings: [
          color: 'rgba(193, 234, 0, 1)'
          lineWidth: 0.5
          xaxis:
            from: values[0] - markerWidth - 3 * markerWidth
            to:   values[0] + markerWidth - 3 * markerWidth
        ,
          color: 'rgba(193, 234, 0, 1)'
          lineWidth: 0.5
          xaxis:
            from: values[1] - markerWidth - 3 * markerWidth
            to:   values[1] + markerWidth - 3 * markerWidth
        ]
      xaxis:
        min: @minimum
        max: @maximum
        show: false
      yaxis:
        show: false

    @markers = $.plot($("#plots .markers"), [{color: '#002332', data: []}], options)
  
  teardown: =>
    console.log 'teardown'
    
    if @slider?
      @slider.destroy() if @slider.hasOwnProperty('destroy')
    $("#plots .histogram").empty()
    $("#plots .markers").empty()
    
    @destroyStretchButtons()
    @destroyBandButtons()
    @destroyMetadata()
    
    @container = null
    
    @stds = null
    @means = null
    @histograms = null
    @images = null
    
    for band, texture of @texture
      @gl.deleteTexture(texture)
    
    @textures = null
    @textureCount = null
    
    if @programs?
      @gl.deleteProgram(program) for program in @programs

    @width = null
    @height = null      
    @gl = null
    @ext = null
    @vertexShader = null
    @programs = null
    @program = null
    
    # Remove the WebGL canvas
    element = document.getElementById('webgl-fits')
    element.parentNode.removeChild(element) if element
    
    
module.exports = FITSViewer