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
    'span.number-of-galaxies'   : 'noOfGalaxies'
    'button[name="reset"]'      : 'resetButton'
    '#loading-animation'        : 'loading'

  events:
    'click #setting-variable-control button'  : 'setGraphType'
    'click #setting-galaxy-type button'       : 'setGalaxyType'
    'click #setting-data-source button'       : 'setDataSource'
    'change #sample-size'                     : 'setSampleSize'
    'change #x-axis'                          : 'setXAxis'
    'change #y-axis'                          : 'setYAxis'
    'click button[name="screenshot"]'         : 'generateImageFromGraph'
    'click button[name="reset"]'              : 'reset'
    'click button[name="download"]'           : 'downloadData'

  groupGalaxySizes: [
    """<option value="">#{ I18n.t('navigator.sample.choose') }</option>""",
    """<option value="10">#{ I18n.t('navigator.sample.small') }</option>""",
    """<option value="50">#{ I18n.t('navigator.sample.medium') }</option>""",
    """<option value="100">#{ I18n.t('navigator.sample.large') }</option>"""
  ]

  allGalaxySizes: [
    """<option value="">#{ I18n.t('navigator.sample.choose') }</option>""",
    """<option value="100">#{ I18n.t('navigator.sample.random_small') }</option>""",
    """<option value="250">#{ I18n.t('navigator.sample.random_medium') }</option>""",
    """<option value="500">#{ I18n.t('navigator.sample.random_large') }</option>"""
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
    @headingText.html "<h2>#{ I18n.t('navigator.construct') }</h2>"

    if @graphType is 'histogram'
      @setPressed $('[data-variables="histogram"]')
    else
      @setPressed $('[data-variables="scatterplot"]')

    @setGraph()

  setGraph: =>
    if @graphType is 'histogram'
      @xAxisItem.find('label').html I18n.t('navigator.histogram.label')
      @graph = new Histogram { el: '#graph', channel: 'graph', height: 310, width: 512 , margin: { left: 50, top: 20, bottom: 40 }, yLabel: I18n.t('navigator.histogram.y_label') }
    else
      @xAxisItem.find('label').html I18n.t('navigator.scatterplot.label')
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
    @setPressed button, false, true
    siblingButton = button.siblings()

    @graph.filters = new Array
    @graph.removeSelectionFilter()

    if button.hasClass('pressed') and siblingButton.hasClass('pressed')
      @options.galaxyType = 'both'
    else if (not button.hasClass('pressed')) and (not siblingButton.hasClass('pressed'))
      @options.galaxyType = null
    else if button.hasClass('pressed')
      @options.galaxyType = button.data('type')
    else
      @options.galaxyType = siblingButton.data('type')

    if @options.galaxyType and @options.galaxyType isnt 'both'
      filter = 
        func: new Function("item", "return item['classification'] === '#{@options.galaxyType}'")
      @graph.filters.push filter
    else if @options.galaxyType is 'both'
      @graph.selectionFilter = (item) -> item['classification'] is 'feature'

    if @options.galaxyType is 'feature'
      @graph.color = 'orange'
    else
      @graph.color = 'teal'

    @graph.start()

    @setButtons.addClass 'show-control'
    @sizeSelector.addClass 'show-control'

    unless @options.galaxyType
      @$('.point').hide()

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

    unless @options.galaxyType 
      @$('.point').hide()

    isRandom = (@options.dataSource is 'all')
    limit = @options.sampleSize
    @loading.show()
    @graph.getDataSource 'InteractiveSubject', {random: isRandom, limit: limit}

    @graph.bind 'data-received', =>
      @loading.hide()
      @resetButton.removeAttr 'disabled'
      @noOfGalaxies.text @graph.filteredData.length

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

  # New CSV Generation
  downloadData: =>
    $.ajax
      type: 'POST'
      data: JSON.stringify(@graph.filteredData)
      url: 'https://jcvd.herokuapp.com/to-csv'
      crossDomain: true
      dataType: 'json'
      contentType: 'application/json'
      success: @downloadIframe
        
  downloadIframe: (data) =>
    $("body").append("""<iframe src="https://jcvd.herokuapp.com/to-csv/#{data.data_url}" style="display: none;"></iframe>""");

  # Helper functions
  updateTitle: =>
    if @graphType is 'histogram'
      @graphTitle.text "#{ I18n.t('navigator.histogram.distribution') } #{@prettyKey(@options.xAxis)}"
    else
      @options.yAxis = '' if typeof(@options.yAxis) is 'undefined'
      @graphTitle.text "#{@prettyKey(@options.xAxis)} #{ I18n.t('navigator.scatterplot.vs') } #{@prettyKey(@options.yAxis)}"

  setPressed: (button, force_selection = true, dual_selection = false) ->
    # Check for case where no button is selected.
    if dual_selection 
      button.toggleClass 'pressed'
      return

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
