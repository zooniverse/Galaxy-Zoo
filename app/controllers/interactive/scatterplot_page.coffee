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
    @options = new Object
    @render()
    @scatterplot = new Scatterplot {el : #scatterplot}

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
   

module.exports = ScatterplotPage
