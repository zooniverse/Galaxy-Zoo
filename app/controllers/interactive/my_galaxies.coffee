Spine = require('spine')
Sample = require 'lib/sample_interactive_data'

class MyGalaxies extends Spine.Controller

  constructor: ->
    super
    @headingText = $('#heading_text')
    @action_title = '<h2>My Galaxies</h2>'

    @samples = Sample.randomSample 10

  active: ->
    super
    @render()
    @headingText.html @action_title
    $('[data-link="my_galaxies"]').addClass 'pressed'

  deactivate: ->
    @el.removeClass 'active'
    @headingText.html ''
    $('[data-link="my_galaxies"]').removeClass 'pressed'

  render: ->
    @html require('views/interactive/my_galaxies')(@)
    for sample in @samples
      @generateChart sample

  formatData: (data) ->
    feature_counts = []
    for key, value of data
      switch key
        when "smooth_count" then key = "Smooth"
        when "disk_count" then key = "Disk"
        when "other_count" then key = "Other"

      feature_counts.push {
          'label': key,
          'value': value
        }
    console.log feature_counts
    feature_counts
    

  generateChart: (sample) ->
    counts = @formatData sample.subject
    chart = nv.models.multiBarHorizontalChart()
      .x (d) ->
        d.label
      .y (d) ->
        d.value
      .showControls(false)
      .showLegend(false)
      .showValues(true)
      .tooltips(false)

    data = [{
        key: 'Galaxy Features',
        values: counts
      }]

    d3.selectAll('.nv-bar text').attr('dy','0.35em')
    d3.select('[data-id="' + sample.classification_id + '"] svg')
      .datum(data)
      .transition().duration(500)
      .call(chart)

    nv.utils.windowResize(chart.update)

module.exports = MyGalaxies