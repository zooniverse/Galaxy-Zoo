Sample = require 'lib/sample_interactive_data'
Scatterplot = require 'ubret/lib/controllers/Scatterplot'
Histogram = require 'ubret/lib/controllers/Histogram'
BaseController = require 'ubret/lib/controllers/BaseController'

class Graphs extends BaseController

  elements:
    '#x-axis-item'              : 'xAxisItem'
    '#y-axis-item'              : 'yAxisItem'
    'h3#graph-title'            : 'graphTitle'
    'a[download="my_data.csv"]' : 'dataDownload'
    '#galaxy-types'             : 'typeButtons'
    '#galaxy-sets'              : 'setButtons'
    '#sample-sizes'             : 'sizeSelector'

  events:
    'click #setting-variable-control button'  : 'setGraphType'
    'click #setting-galaxy-type button'       : 'setGalaxyType'
    'click #setting-data-source button'       : 'setDataSource'
    'change #sample-size'                     : 'setSampleSize'
    'change #x-axis'                          : 'setXAxis'
    'change #y-axis'                          : 'setYAxis'
    'click button[name="screenshot"]'         : 'generateImageFromGraph'
    'click button[name="reset"]'              : 'reset'

  constructor: ->
    super
    @headingText = $('#heading_text')
    @graph
    @options = new Object

  render: =>
    @html require('views/interactive/graphs')(@)

  # Routing callbacks
  active: (params) =>
    super
    @render()
    
    @setPressed $('[data-link="graphs"]')
    @setPressed $('[data-source="group"]')

    @options = new Object
    @headingText.html '<h2>Construct Your Question</h2>'

    @options.graphType = params.graphType or 'histogram'

    if @options.graphType is 'histogram'
      @setPressed $('[data-variables="histogram"]')
      @xAxisItem.find('label').html 'I\'d like to see...'
      @graph = new Histogram { el: '#graph', channel: 'graph', height: 310, width: 512 } 
    else
      @setPressed $('[data-variables="scatterplot"]')
      @graph = new Scatterplot { el: '#graph', channel: 'graph', height: 310, width: 512 } 

  deactivate: =>
    super
    @el.removeClass("active")
    @headingText.html @action_title
    $('[data-link="graphs"]').removeClass 'pressed'

  setGraph: =>
    if @options.graphType is 'histogram'
      @xAxisItem.find('label').html 'I\'d like to see...'
      @graph = new Histogram { el: '#graph', channel: 'graph', height: 310, width: 512 } 
    else
      @xAxisItem.find('label').html 'I\'d like to see how...'
      @graph = new Scatterplot { el: '#graph', channel: 'graph', height: 310, width: 512 } 


  # Graph interface functions
  setGraphType: (e) =>
    button = $(e.currentTarget)
    @options.graphType = button.data('variables')

    @setPressed button
    @el.find('svg').empty()
    @reset()

    @setGraph()

  setXAxis: (e) =>
    @options.xAxis = $(e.currentTarget).val()
    @updateTitle()

    if @options.graphType is 'histogram'
      @typeButtons.addClass 'show-control'
      @graph.setVariable @options.xAxis
    else
      @yAxisItem.addClass 'show-control' 
      @graph.setXVar @options.xAxis

  setYAxis: (e) =>
    @options.yAxis = $(e.currentTarget).val()
    @updateTitle()
    @typeButtons.addClass 'show-control'

    @graph.setYVar @options.yAxis

  setGalaxyType: (e) =>
    button = $(e.currentTarget)
    @graph.filters = new Array

    if button.hasClass 'pressed'
      @options.galaxyType = null
    else
      @options.galaxyType = button.data('type')

    if @options.galaxyType
      filter = 
        func: new Function("item", "return item['type'] === '#{@options.galaxyType}_count'")
      @graph.filters.push filter

    if @options.galaxyType is 'disk'
      @graph.color = 'orange'
    else
      @graph.color = 'teal'

    @graph.start()

    @setPressed button, false
    @setButtons.addClass 'show-control'
    @sizeSelector.addClass 'show-control'

  setDataSource: (e) =>
    button = $(e.currentTarget)
    @options.dataSource = button.data('source')

    if not (button.hasClass 'pressed')
      @sizeSelector.find('option').toggle()  
      @sizeSelector.find('option[value=""]').show()
    @setPressed button

  setSampleSize: (e) =>
    @options.sampleSize = $(e.currentTarget).val()

    isRandom = (@options.dataSource is 'all')
    limit = @options.sampleSize
    @graph.getDataSource 'InteractiveSubject', {random: isRandom, limit: limit}

    @graph.bind 'data-recieved', =>
      dataURI = "data:text/csv;charset=UTF-8," + encodeURIComponent(@generateCSV())
      @dataDownload.attr 'href', dataURI

  reset: (e) =>
    @render()
    @options = {graphType: @options.graphType}

    @setPressed $('[data-link="graphs"]')
    @setPressed $('[data-source="group"]')
    @setPressed $("[data-variables=\"#{@options.graphType}\"]")

    @setGraph()

  # Image Generation
  generateImageFromGraph: (e) =>
    svg_string = @serializeXmlNode document.querySelector '#graph svg'
    canvg 'canvas', svg_string

    canvas = document.getElementById 'canvas'
    img = canvas.toDataURL 'image/png'
    window.open img

  # CSV Generation
  generateCSV: =>
    headerString = (@createCSVHeader(@graph.filteredData[0]) + '\n').slice(1)
    bodyString = @createCSVBody @graph.filteredData
    return headerString + bodyString
      
  createCSVHeader: (datum, prefix='') =>
    header = new String
    for key, value of datum
      if typeof(value) is 'object'
        header = header + @createCSVHeader value, "#{key}_"
      else
        header = header + "," + prefix + key
    return header

  createCSVBody: (data) =>
    body = new Array
    body.push (@createCSVLine(datum)).slice(1) for datum in data
    return body.join '\n'

  createCSVLine: (datum) =>
    line = new String
    for key, value of datum
      if typeof(value) is 'object'
        line = line + @createCSVLine value
      else
        line = line + "," + value
    return line

  # Helper functions
  updateTitle: =>
    if @options.graphType is 'histogram'
      @graphTitle.text "Distribution of #{@prettyKey(@options.xAxis)}"
    else
      @options.yAxis = '' if typeof(@options.yAxis) is 'undefined'
      @graphTitle.text "#{@prettyKey(@options.xAxis)} vs. #{@prettyKey(@options.yAxis)}"

  setPressed: (button, force_selection = true) =>
    # Check for case where no button is selected.
    unless button.parent().find('button').hasClass 'pressed'
      button.addClass 'pressed'
      return

    if button.hasClass 'pressed'
      unless force_selection
        button.siblings().removeClass 'pressed'
        button.toggleClass 'pressed'
    else 
      button.siblings().removeClass 'pressed'
      button.toggleClass 'pressed'
   
  serializeXmlNode: (xmlNode) ->
    if typeof window.XMLSerializer != "undefined"
      (new window.XMLSerializer()).serializeToString(xmlNode)
    else if typeof xmlNode.xml != "undefined"
      xmlNode.xml

module.exports = Graphs