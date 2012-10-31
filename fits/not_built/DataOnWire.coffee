
# Collection of functions that are embedded in an iframe on S3.  These functions provide a way to
# circumvent cross-origin XHR commands.
class DataOnWire
  validOrigins: [
    "http://www.galaxyzoo.org",
    "http://0.0.0.0:9294",
    "http://0.0.0.0:1024",
    "http://www.galaxyzoo.org.s3-website-us-east-1.amazonaws.com"
  ]
  
  # TODO: Find out which files are in GDS_stamps_large_2epoch
  hstDirs:
    COS: 'COS_stamps_large'
    GDS: 'GDS_stamps_large'
    UDS: 'UDS_stamps_large'
  
  constructor: ->
    window.addEventListener("message", @receiveMessage, false)
  
  getHubblePath: (id) =>
    # Exampes are COS_xxxxx, UDS_xxxxx, GDS_xxxxxx
    # COS AGZ000080v
    # GDS AGZ0000zhn
    # UDS ?
    
    pattern = /(COS|UDS|GDS)_\d+/
    match = id.match(pattern)
    return unless match?
    
    prefix = match[1]
    directory = "hst/#{@hstDirs[prefix]}"
    
    return "#{directory}/#{id}"
  
  receiveMessage: (e) =>
    @validOrigin = e.origin in @validOrigins
    return unless @validOrigin
    @origin = e.origin
    
    # Cache the needed values
    data = e.data
    survey = data.survey
    id = data.id
    
    # Get the bands and directory based on the survey
    if survey is 'sloan'
      directory = "dr9zoo/#{id}"
      bands = ['u', 'g', 'r', 'i', 'z']
    else
      directory = @getHubblePath(id)
      bands = ['h', 'i', 'j']
    
    # console.log directory, bands
    
    for band in bands
      do (band, directory) =>
        url = "#{directory}_#{band}.fits.fz"
        # console.log url
        
        xhr = new XMLHttpRequest()
        xhr.open('GET', url)
        xhr.responseType = 'arraybuffer'
        
        xhr.onreadystatechange = (e) =>
          target = e.target
          status = target.status
          ready = target.readyState
          if ready is 4 and status is 200
            msg =
              origin: url
              band: band
              arraybuffer: target.response
            @sendMessage(msg)
          
        xhr.send()
  
  sendMessage: (msg) =>
    # console.log "Attempting to post message to #{@origin}"
    window.parent.postMessage(msg, @origin)
  
@DataOnWire = DataOnWire