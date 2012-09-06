WebGL =

  vertexShader: [
      "attribute vec2 a_position;",
      "attribute vec2 a_textureCoord;",
      
      "uniform vec2 u_offset;",
      "uniform float u_scale;",
      
      "varying vec2 v_textureCoord;",
      
      "void main() {",
          "vec2 position = a_position + u_offset;",
          "position = position * u_scale;",
          "gl_Position = vec4(position, 0.0, 1.0);",
          
          # Pass coordinate to fragment shader
          "v_textureCoord = a_textureCoord;",
      "}"
    ].join("\n")
  
  fragmentShaders:
      linear: [
        "precision mediump float;",
        
        "uniform sampler2D u_tex;",
        "uniform vec2 u_extremes;",
        
        "varying vec2 v_textureCoord;",
        
        "void main() {",
            "vec4 pixel_v = texture2D(u_tex, v_textureCoord);",
            
            "float min = u_extremes[0];",
            "float max = u_extremes[1];",
            "float pixel = (pixel_v[0] - min) / (max - min);",
            
            "gl_FragColor = vec4(pixel, pixel, pixel, 1.0);",
        "}"
      ].join("\n")
      logarithm: [
        "precision mediump float;"
        
        "uniform sampler2D u_tex;",
        "uniform vec2 u_extremes;",
        
        "varying vec2 v_textureCoord;",

        "float logarithm(float value) {",
            "return log(value / 0.05 + 1.0) / log(1.0 / 0.05 + 1.0);",
        "}",

        "void main() {",
            "vec4 pixel_v = texture2D(u_tex, v_textureCoord);",
            
            "float min = logarithm(u_extremes[0]);",
            "float max = logarithm(u_extremes[1]);",
            "float pixel = logarithm(pixel_v[0]);",
            
            "pixel = (pixel - min) / (max - min);",
            
            "gl_FragColor = vec4(pixel, pixel, pixel, 1.0);",
        "}"
      ].join("\n")
      sqrt: [
        "precision mediump float;"
        
        "uniform sampler2D u_tex;",
        "uniform vec2 u_extremes;",
        
        "varying vec2 v_textureCoord;",

        "void main() {",
          "vec4 pixel_v = texture2D(u_tex, v_textureCoord);",
        
          "float min = sqrt(u_extremes[0]);",
          "float max = sqrt(u_extremes[1]);",
          "float pixel = (sqrt(pixel_v[0]) - min) / (max - min);",
        
          "gl_FragColor = vec4(pixel, pixel, pixel, 1.0);",
        "}"
      ].join("\n")
      arcsinh: [
        "precision mediump float;"
        
        "uniform sampler2D u_tex;",
        "uniform vec2 u_extremes;",
        
        "varying vec2 v_textureCoord;",

        "float arcsinh(float value) {",
            "return log(value + sqrt(1.0 + value * value));",
        "}",

        "void main() {",
          "vec4 pixel_v = texture2D(u_tex, v_textureCoord);",
          
          "float min = arcsinh(u_extremes[0]);",
          "float max = arcsinh(u_extremes[1]);",
          "float value = arcsinh(pixel_v[0]);",

          "float pixel = (value - min) / (max - min);",

          "gl_FragColor = vec4(pixel, pixel, pixel, 1.0);",
        "}"
      ].join("\n")
      power: [
        "precision mediump float;"
        
        "uniform sampler2D u_tex;",
        "uniform vec2 u_extremes;",
        
        "varying vec2 v_textureCoord;",

        "void main() {",
          "vec4 pixel_v = texture2D(u_tex, v_textureCoord);",

          "float min = pow(u_extremes[0], 2.0);",
          "float max = pow(u_extremes[1], 2.0);",

          "float pixel = (pow(pixel_v[0], 2.0) - min) / (max - min);",

          "gl_FragColor = vec4(pixel, pixel, pixel, 1.0);",
        "}"
      ].join("\n")
      color: [
            "precision mediump float;",
            "uniform vec2 u_resolution;",

            "uniform sampler2D u_tex_g;",
            "uniform sampler2D u_tex_r;",
            "uniform sampler2D u_tex_i;",
            "uniform vec2 u_extremes;",

            "float arcsinh(float value) {",
                "return log(value + sqrt(1.0 + value * value));",
            "}",

            "float f(float minimum, float maximum, float value) {",
                "float pixel = clamp(value, minimum, maximum);",
                "float alpha = 0.02;",
                "float Q = 8.0;",
                "return arcsinh(alpha * Q * (pixel - minimum)) / Q;",
            "}",

            "void main() {",
                "vec2 texCoord = gl_FragCoord.xy / u_resolution;",
                "vec4 pixel_v_g = texture2D(u_tex_g, texCoord);",
                "vec4 pixel_v_r = texture2D(u_tex_r, texCoord);",
                "vec4 pixel_v_i = texture2D(u_tex_i, texCoord);",

                "float minimum = u_extremes[0];",
                "float maximum = u_extremes[1];",
                "float g = pixel_v_g[0];",
                "float r = pixel_v_r[0];",
                "float i = pixel_v_i[0];",
                "float I = (g + r + i) / 3.0;",
                "float fI = f(minimum, maximum, I);",
                "float fII = fI / I;",

                "float R = i * fII;",
                "float G = r * fII;",
                "float B = g * fII;",

                "float RGBmax = max(max(R, G), B);",

                "if (RGBmax > 1.0) {",
                  "R = R / RGBmax;",
                  "G = G / RGBmax;",
                  "B = B / RGBmax;",
                "}",
                "if (I == 0.0) {",
                  "R = 0.0;",
                  "G = 0.0;",
                  "B = 0.0;",
                "}",

                "gl_FragColor = vec4(R, G, B, 1.0);",
            "}"
          ].join("\n")

  # TODO: This function is not working ...
  check: ->
    unless window.WebGLRenderingContext
      alert('Sorry, you need a WebGL enabled browser to use this application')
      return false
    return true
  
  # WebGL needs a canvas for drawing
  setupCanvas: (container, width, height) ->
    
    # Create a canvas within the container with specified width and height
    canvas = document.createElement('canvas')
    canvas.setAttribute('id', 'webgl-fits')
    canvas.setAttribute('width', width)
    canvas.setAttribute('height', height)
    
    # Append canvas to container
    container.appendChild(canvas)
    
    return canvas
  
  create3DContext: (canvas, opt_attribs) ->
    names = ["webgl", "experimental-webgl"]
    context = null
    for name in names
      try
        context = canvas.getContext(name, opt_attribs)
      catch e
      break if (context)
      
    return context

  loadShader: (gl, source, type) ->
    shader = gl.createShader(type)
    gl.shaderSource(shader, source)
    gl.compileShader(shader)
    
    compiled = gl.getShaderParameter(shader, gl.COMPILE_STATUS)
    
    unless compiled
      lastError = gl.getShaderInfoLog(shader)
      throw "Error compiling shader #{shader}: #{lastError}"
      gl.deleteShader(shader)
      return null

    return shader

  createProgram: (gl, shaders, opt_attribs, opt_locations) ->
    program = gl.createProgram()
    for shader in shaders
      gl.attachShader(program, shader)
    
    if opt_attribs?
      for attribute, index in opt_attribs
        options = if opt_locations? then opt_locations[index] else index
        gl.bindAttribLocation(program, options, attribute)
    
    gl.linkProgram(program)
    
    linked = gl.getProgramParameter(program, gl.LINK_STATUS)
    unless linked
      throw "Error in program linking: #{gl.getProgramInfoLog(program)}"
      gl.deleteProgram(program)
      return null
    
    return program

module?.exports = WebGL