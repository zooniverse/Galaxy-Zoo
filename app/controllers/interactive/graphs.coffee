Spine = require 'spine'
Sample = require 'lib/sample_interactive_data'
Scatterplot = require 'ubret/lib/controllers/Scatterplot'
Histogram = require 'ubret/lib/controllers/Histogram'
InteractiveSubject = require 'ubret/lib/models/InteractiveSubject'

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
          @yAxisItem.css 'opacity', 0
        when "scatterplot"
          @options.graphType = 'scatterplot'
          @setPressed $('[data-variables="scatterplot"]')
          @yAxisItem.css 'opacity', 1

  deactivate: ->
    @el.removeClass("active")
    @headingText.html @action_title
    $('[data-link="graphs"]').removeClass 'pressed'


  # Graph interface functions
  setXAxis: (e) =>
    @options.xAxis = $(e.currentTarget).val()

  setYAxis: (e) =>
    @options.yAxis = $(e.currentTarget).val()

  setGraphType: (e) =>
    button = $(e.currentTarget)
    @options.graphType = button.data('variables')
    @setPressed button

    switch $(e.currentTarget).data('variables')
      when "histogram"
        @yAxisItem.css 'opacity', 0
        @xAxisItem.find('label').html 'I\'d like to see...'
      when "scatterplot"
        @yAxisItem.css 'opacity', 1
        @xAxisItem.find('label').html 'I\'d like to see how...'

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
        @graph = new Histogram {el: '#graph', width: 512, height: 310}
      when "scatterplot"
        @graph = new Scatterplot {el: '#graph'}
        @graph.xAxis = @options.xAxis
        @graph.yAxis = @options.yAxis

    @graph.channel = 'graph'

    filter = {}
    if @options.galaxyType
      filter.func = new Function "item", "return item['type'] === '#{@options.galaxyType}'"
      @graph.filters.push filter

    @graph.getDataSource("SkyServerSubject", @options.sampleSize)


    # @histogram.getDataSource("InteractiveSubject", {sample: @options.sample, limit: parseInt(@sampleSize.val()), user: false})

  # Helper functions
  setPressed: (button) =>
    button.siblings().removeClass 'pressed'
    button.toggleClass 'pressed'
   

module.exports = Graphs