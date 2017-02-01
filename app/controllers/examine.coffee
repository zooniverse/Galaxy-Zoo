Spine = require 'spine'
Subject = require 'models/subject'
Api = require 'zooniverse/lib/api'
FITSViewer = ->

class Examine extends Spine.Controller
  
  events:
    "click #load-fits": "requestFITS"
  
  
  constructor: ->
    super
    @fitsLoaded = false
  
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
    #if @checkBrowserFeatures()
    #  $('#controls').html require('views/examine/fitsviewer')()
  
  info: (key, values...) =>
    value = values.shift()
    return unless value
    
    """
      <div class="row">
        <span class="key">#{ key }:</span>
        <span class="value">#{ value } #{ values.join(' ') }</span>
      </div>
    """
  
  # TODO: Move this into Zooniverse library
  checkBrowserFeatures: =>
    checkDataView = DataView?
    checkWorker = Worker?
    checkWebGL = window.WebGLRenderingContext?
    if checkWebGl
      canvas = document.createElement('canvas')
      context = canvas.getContext('webgl')
      checkWebGl = context?
    else
      checkWebGl = false
    checkDataView and checkWorker and checkWebGL
  
  requestFITS: =>
    # Deactive button
    $('#load-fits').attr("disabled", true)

    if @fitsLoaded
      @initializeFitsViewer()
    else
      fetcher = $.ajax
        url: '/fits.js'
        dataType: 'script'
        cache: true
      
      fetcher.done =>
        FITSViewer = require 'controllers/fitsviewer'
        # require('lib/jquery.flot')
        # require('lib/jquery.flot.axislabels')
        # require('lib/jquery-ui-1.9.1.custom')
        @fitsLoaded = true
        @initializeFitsViewer()
   
  initializeFitsViewer: =>
    id      = @subject.metadata.sdss_id or @subject.metadata.hubble_id
    survey  = @subject.metadata.survey
    switch survey
      when "sloan"
        bands = ['u', 'g', 'r', 'i', 'z']
      when "ukidss"
        bands = ['y', 'h', 'j', 'k']
      else
        bands = ['h', 'i', 'j']
    
    # Initialize viewer
    @viewer = new FITSViewer({el: $('#examine'), bands: bands, survey: survey, survey_id: id})
  
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

module.exports = Examine
