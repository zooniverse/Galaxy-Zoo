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

  groupGalaxySizes: [
    '<option value="">Choose sample size</option>',
    '<option value="10">10 galaxies</option>',
    '<option value="50">50 galaxies</option>',
    '<option value="100">100 galaxies</option>'
  ]

  allGalaxySizes: [            
    '<option value="">Choose sample size</option>',
    '<option value="250">250 randomly selected galaxies</option>',
    '<option value="500">500 randomly selected galaxies</option>'
  ]

  constructor: ->
    super
    @headingText = $('#heading_text')
    @graph
    @options = new Object

  render: =>
    $('[data-link="my_galaxies"]').removeClass 'pressed'
    @html require('views/interactive/graphs')(@)

    @setPressed $('[data-link="graphs"]')
    @setPressed $('[data-source="group"]')

    @options = new Object
    @headingText.html '<h2>Construct Your Question</h2>'

    if @graphType is 'histogram'
      @setPressed $('[data-variables="histogram"]')
      @xAxisItem.find('label').html 'I\'d like to see...'
      @graph = new Histogram { el: '#graph', channel: 'graph', height: 310, width: 512 } 
    else
      @setPressed $('[data-variables="scatterplot"]')
      @graph = new Scatterplot { el: '#graph', channel: 'graph', height: 310, width: 512, margin: { left: 50, top: 20, bottom: 40 } }

  setGraph: =>
    if @graphType is 'histogram'
      @xAxisItem.find('label').html 'I\'d like to see...'
      @graph = new Histogram { el: '#graph', channel: 'graph', height: 310, width: 512 } 
    else
      @xAxisItem.find('label').html 'I\'d like to see how...'
      @graph = new Scatterplot { el: '#graph', channel: 'graph', height: 310, width: 512, margin: { left: 50, top: 20, bottom: 40 } } 

  # Graph interface functions
  setGraphType: (e) =>
    button = $(e.currentTarget)
    @graphType = button.data('variables')

    @setPressed button
    @el.find('svg').empty()
    @reset()

    @setGraph()

  setXAxis: (e) =>
    @options.xAxis = $(e.currentTarget).val()
    @updateTitle()

    if @graphType is 'histogram'
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
        func: new Function("item", "return item['classification'] === '#{@options.galaxyType}'")
      @graph.filters.push filter

    if @options.galaxyType is 'feature'
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

    if @options.dataSource is 'group'
      @sizeSelector.find('select').html @groupGalaxySizes.join('\n')
    else
      @sizeSelector.find('select').html @allGalaxySizes.join('\n')
    @setPressed button

  setSampleSize: (e) =>
    @options.sampleSize = $(e.currentTarget).val()

    isRandom = (@options.dataSource is 'all')
    limit = @options.sampleSize
    @graph.getDataSource 'InteractiveSubject', {random: isRandom, limit: limit}

    @graph.bind 'data-received', =>
      dataURI = "data:text/csv;charset=UTF-8," + encodeURIComponent(@generateCSV())
      @dataDownload.attr 'href', dataURI

  reset: (e) =>
    @render()
    @options = new Object

    @setPressed $('[data-link="graphs"]')
    @setPressed $('[data-source="group"]')
    @setPressed $("[data-variables=\"#{@graphType}\"]")

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
      unless typeof(value) is 'function'
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
      unless typeof(value) is 'function'
        if typeof(value) is 'object'
          line = line + @createCSVLine value
        else
          line = line + "," + value
    return line

  # Helper functions
  updateTitle: =>
    if @graphType is 'histogram'
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