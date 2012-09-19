Spine = require 'spine'
Histogram = require 'ubret/lib/controllers/Histogram'

class HistogramPage extends Spine.Controller 
  events: 
    submit: 'onSubmit'
    'click button[name="two-variable"]' : 'switchGraph'
    'click .galaxy-select button' : 'setGalaxyType'
    'click .samples button' : 'setSample'

  elements: 
    'select.x-axis'      : 'xAxis'
    'select.sample-size' : 'sampleSize'

  constructor: ->
    super

  render: =>
    @html require('views/interactive/histogram')(@)

  active: ->
    super
    @el.addClass 'active'
    @options = new Object
    @render()
    @histogram = new Histogram {el : '#histogram'}
    $('[data-link="graphs"]').addClass 'active'

  deactivate: ->
    @el.removeClass 'active'
    $('[data-link="graphs"]').removeClass 'active'

  switchGraph: (e) =>
    e.preventDefault()
    @navigate '/navigator/histogram'

  onSubmit: (e) =>
    e.preventDefault()

    @histogram.variable = @xAxis.val()

    filter = new Function "item", "return item['type'] === #{@options.galaxyType}"
    @histogram.addFilter filter

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
   

module.exports = HistogramPage 
