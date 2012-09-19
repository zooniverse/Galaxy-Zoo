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
    @scatterplot = new Scatterplot {el : #scatterplot}

  render: =>
    @html require('views/interactive/histogram')(@)

  switchGraph: (e) =>
    e.preventDefault()
    @navigate '/navigator/Scatterplot'

  onSubmit: (e) =>
    e.preventDefault()

    @scatterplot.xAxis = @xAxis.val()
    @scatterplot.yAxis = @yAxis.val()

    filter = new Function "item", "return item['type'] === #{@options.galaxyType}"
    @scatterplot.addFilter filter

    fetcher = InteractiveSubject.fetch(@options.sample, parseInt(@sampleSize.val()))
    fetcher.onSuccess =>
      @scatterplot.data = InteractiveSubject.all()
      @scatterplot.start()

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
