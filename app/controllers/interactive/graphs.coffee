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

  events:
    'click #setting-variable-control button'  : 'setGraphType'
    'click #setting-galaxy-type button'       : 'setGalaxyType'
    'click #setting-data-source button'       : 'setDataSource'
    'change #sample-size'                     : 'setSampleSize'
    'click button[type="submit"]'             : 'onSubmit'
    'change #x-axis'                          : 'setXAxis'
    'change #y-axis'                          : 'setYAxis'
    'click button[name="screenshot"]'         : 'generateImageFromGraph'

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
    @setPressed $('[data-source="all"]')

    @options = new Object
    @headingText.html '<h2>Construct Your Question</h2>'

    @options.graphType = params.graphType or 'histogram'


    switch @options.graphType
      when "histogram"
        @options.graphType = 'histogram'
        @setPressed $('[data-variables="histogram"]')
        @xAxisItem.find('label').html 'I\'d like to see...'
        @yAxisItem.addClass 'unselectable'
        @yAxisItem.find('select').attr 'disabled', 'disabled'
      when "scatterplot"
        @options.graphType = 'scatterplot'
        @setPressed $('[data-variables="scatterplot"]')
        @yAxisItem.removeClass 'unselectable'
        @yAxisItem.find('select').removeAttr 'disabled'

  deactivate: ->
    super
    @el.removeClass("active")
    @headingText.html @action_title
    $('[data-link="graphs"]').removeClass 'pressed'


  # Graph interface functions
  updateTitle: =>
    switch @options.graphType
      when 'histogram'
        @graphTitle.text "Distribution of #{@prettyKey(@options.xAxis)}"
      when 'scatterplot'
        @graphTitle.text "#{@prettyKey(@options.xAxis)} vs. #{@prettyKey(@options.yAxis)}"

  setXAxis: (e) =>
    @options.xAxis = $(e.currentTarget).val()
    @updateTitle()

  setYAxis: (e) =>
    @options.yAxis = $(e.currentTarget).val()
    @updateTitle()

  setGraphType: (e) =>
    button = $(e.currentTarget)
    @options.graphType = button.data('variables')
    @setPressed button

    switch $(e.currentTarget).data('variables')
      when "histogram"
        @xAxisItem.find('label').html 'I\'d like to see...'
        @yAxisItem.addClass 'unselectable'
        @yAxisItem.find('select').attr 'disabled', 'disabled'
      when "scatterplot"
        @xAxisItem.find('label').html 'I\'d like to see how...'
        @yAxisItem.removeClass 'unselectable'
        @yAxisItem.find('select').removeAttr 'disabled'

  setGalaxyType: (e) =>
    button = $(e.currentTarget)
    if button.hasClass 'pressed'
      @options.galaxyType = null
    else
      @options.galaxyType = button.data('type')
    @setPressed button, false

  setDataSource: (e) =>
    button = $(e.currentTarget)
    @options.dataSource = button.data('source')
    @setPressed button

  setSampleSize: (e) =>
    @options.sampleSize = $(e.currentTarget).val()

  generateImageFromGraph: (e) =>
    svg_string = @serializeXmlNode document.querySelector '#graph svg'
    canvg 'canvas', svg_string

    canvas = document.getElementById 'canvas'
    img = canvas.toDataURL 'image/png'
    window.open img

  onSubmit: (e) =>
    e.preventDefault()

    # Validation
    switch @options.graphType
      when 'histogram'
        unless $('#x-axis').val()
          $('#x-axis').addClass 'error'
          return
        else
          $('#x-axis').removeClass 'error'
      when 'scatterplot'
        unless $('#x-axis').val()
          $('#x-axis').addClass 'error'
          return
        else
          $('#x-axis').removeClass 'error'

        unless $('#y-axis').val()
          $('#y-axis').addClass 'error'
          return
        else
          $('#y-axis').removeClass 'error'

    unless @options.sampleSize
      $('#sample-size').addClass 'error'
      return
    else
      $('#sample-size').removeClass 'error'
    # End validation

    # Clear previous graph
    @el.find('svg').empty()

    switch @options.graphType
      when "histogram"
        @graph = new Histogram {el: '#graph', width: 512, height: 310, variable: @options.xAxis}
      when "scatterplot"
        @graph = new Scatterplot {el: '#graph', width: 512, height: 310, xAxisKey: @options.xAxis, yAxisKey: @options.yAxis}

    @graph.channel = 'graph'

    filter = {}
    if @options.galaxyType
      filter.func = new Function "item", "return item['type'] === '#{@options.galaxyType}'"
      @graph.filters.push filter

    @graph.receiveData Sample.randomSample @options.sampleSize
    # @graph.getDataSource("SkyServerSubject", @options.sampleSize)
    # @graph.getDataSource("InteractiveSubject", {sample: @options.sample, limit: parseInt(@sampleSize.val()), user: false})
    
    dataURI = "data:text/csv;charset=UTF-8," + encodeURIComponent(@generateCSV())
    @dataDownload.attr 'href', dataURI

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