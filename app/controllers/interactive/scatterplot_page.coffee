Spine = require 'spine'
Scatterplot = require 'ubret/lib/controllers/Scatterplot'
InteractiveSubject = require 'ubret/lib/models/InteractiveSubject'

class ScatterplotPage extends Spine.Controller
  events: 
    submit: 'onSubmit'
    'click button[name="one-variable"]' : 'switchGraph'
    'click .galaxy-select button' : 'setGalaxyType'
    'click .samples button' : 'setSample'

  elements: 
    'select.y-axis'      : 'yAxis'
    'select.x-axis'      : 'xAxis'
    'select.sample-size' : 'sampleSize'

  constructor: ->
    super

  active: ->
    super
    $('[data-link="graphs"]').addClass 'active'
    @options = new Object
    @render()
    @scatterplot = new Scatterplot {el : '#scatterplot'}

  deactivate: ->
    @el.removeClass("active")
    $('[data-link="graphs"]').removeClass 'active'

  render: =>
    @html require('views/interactive/scatterplot')(@)

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
   

module.exports = ScatterplotPage
