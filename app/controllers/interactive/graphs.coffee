Spine = require 'spine'
Sample = require 'lib/sample_interactive_data'
Scatterplot = require 'ubret/lib/controllers/Scatterplot'
Histogram = require 'ubret/lib/controllers/Histogram'
InteractiveSubject = require 'ubret/lib/models/InteractiveSubject'

class Graphs extends Spine.Controller

  events:
    'click #setting-variable-control button'  : 'setGraphType'
    'click #setting-galaxy-type button'       : 'setGalaxyType'
    'click #setting-data-source button'       : 'setGalaxyType'
    'change #sample_size'                     : 'setSampleSize'
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
        when "scatterplot"
          @options.graphType = 'scatterplot'
          @setPressed $('[data-variables="scatterplot"]')

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

  setGalaxyType: (e) =>
    button = $(e.currentTarget)
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
        @graph = new Histogram {el: '#graph'}
      when "scatterplot"
        @graph = new Scatterplot {el: '#graph'}
        @graph.xAxis = @options.xAxis
        @graph.yAxis = @options.yAxis

    @graph.width = 512
    @graph.height = 310
    @graph.channel = 'graph'
    @graph.getDataSource("SkyServerSubject", @options.sampleSize)

    filter = new Function "item", "return item['type'] === #{@options.galaxyType}"
    @graph.addFilter filter

    # @histogram.getDataSource("InteractiveSubject", {sample: @options.sample, limit: parseInt(@sampleSize.val()), user: false})

  # Helper functions
  setPressed: (button) =>
    button.siblings().removeClass 'pressed'
    button.addClass 'pressed'
   

module.exports = Graphs