Spine = require 'spine'
Sample = require 'lib/sample_interactive_data'
Scatterplot = require 'ubret/lib/controllers/Scatterplot'
Histogram = require 'ubret/lib/controllers/Histogram'

class Graphs extends Spine.Controller

  elements:
    '#x-axis-item': 'xAxisItem'
    '#y-axis-item': 'yAxisItem'

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
    $('[data-link="graphs"]').addClass 'pressed'
    @options = new Object
    @headingText.html '<h2>Construct Your Question</h2>'

    if params.graphType
      switch params.graphType
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
    @el.removeClass("active")
    @headingText.html @action_title
    $('[data-link="graphs"]').removeClass 'pressed'


  # Graph interface functions
  setXAxis: (e) =>
    console.log $(e.currentTarget).val()
    @options.xAxis = $(e.currentTarget).val()

  setYAxis: (e) =>
    console.log $(e.currentTarget).val()
    @options.yAxis = $(e.currentTarget).val()

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
    @setPressed button

  setDataSource: (e) =>
    button = $(e.currentTarget)
    @options.dataSource = button.data('source')
    @setPressed button

  setSampleSize: (e) =>
    @options.sampleSize = $(e.currentTarget).val()

  onSubmit: (e) =>
    e.preventDefault()
    @el.find('svg').empty()

    switch @options.graphType
      when "histogram"
        @graph = new Histogram {el: '#graph', width: 512, height: 310, variable: @options.xAxis}
      when "scatterplot"
        @graph = new Scatterplot {el: '#graph', xAxisKey: @options.xAxis, yAxisKey: @options.yAxis}

    @graph.channel = 'graph'

    filter = {}
    if @options.galaxyType
      filter.func = new Function "item", "return item['type'] === '#{@options.galaxyType}'"
      @graph.filters.push filter

    @graph.receiveData Sample.randomSample @options.sampleSize
    # @graph.getDataSource("SkyServerSubject", @options.sampleSize)
    # @histogram.getDataSource("InteractiveSubject", {sample: @options.sample, limit: parseInt(@sampleSize.val()), user: false})

  # Helper functions
  setPressed: (button) =>
    button.siblings().removeClass 'pressed'
    button.toggleClass 'pressed'

module.exports = Graphs