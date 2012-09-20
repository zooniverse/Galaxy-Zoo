Spine = require 'spine'
Scatterplot = require 'ubret/lib/controllers/Scatterplot'
Histogram = require 'ubret/lib/controllers/Histogram'
InteractiveSubject = require 'ubret/lib/models/InteractiveSubject'

class Graphs extends Spine.Controller

  constructor: ->
    super
    @headingText = $('#heading_text')

  active: =>
    super
    @render()
    $('[data-link="graphs"]').addClass 'pressed'
    @options = new Object
    @headingText.html '<h2>Construct Your Question</h2>'
    @scatterplot = new Scatterplot {el : '#scatterplot'}

  deactivate: ->
    @el.removeClass("active")
    @headingText.html @action_title
    $('[data-link="graphs"]').removeClass 'pressed'

  render: =>
    @html require('views/interactive/graphs')(@)

  switchGraph: (e) =>
    e.preventDefault()
    @navigate '/navigator/histogram'

  onSubmit: (e) =>
    e.preventDefault()

    @scatterplot.xAxis = @xAxis.val()
    @scatterplot.yAxis = @yAxis.val()

    filter = new Function "item", "return item['type'] === #{@options.galaxyType}"
    @scatterplot.addFilter filter

    @histogram.getDataSource("InteractiveSubject", {sample: @options.sample, limit: parseInt(@sampleSize.val()), user: false})

  setGalaxyType: (e) =>
    e.preventDefault()
    button = $(e.currentTarget)
    @options['galaxyType'] = button.attr 'name'
    setPressed button

  setSample: (e) =>
    e.preventDefault()
    button = $(e.currentTarget)
    @options['sample'] = button.attr 'name'
    setPressed button

  setPressed: (button) =>
    button.addClass 'pressed'
    button.siblings().removeClass 'pressed'
   

module.exports = Graphs