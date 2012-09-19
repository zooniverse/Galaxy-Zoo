Spine = require 'spine'
Histogram = require 'ubret/lib/controllers/Histogram'
InteractiveSubject = require 'ubret/lib/models/InteractiveSubject'

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
    @options = new Object
    @render()
    @histogram = new Histogram {el : '#histogram'}

  render: =>
    @html require('views/interactive/histogram')(@)

  switchGraph: (e) =>
    e.preventDefault()
    @navigate '/navigator/histogram'

  onSubmit: (e) =>
    e.preventDefault()

    @histogram.xAxis = @xAxis.val()
    @histogram.yAxis = @yAxis.val()

    filter = new Function "item", "return item['type'] === #{@options.galaxyType}"
    @histogram.addFilter filter

    fetcher = InteractiveSubject.fetch(@options.sample, parseInt(@sampleSize.val()))
    fetcher.onSuccess =>
      @histogram.data = InteractiveSubject.all()
      @histogram.start()

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
