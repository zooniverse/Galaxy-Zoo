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
    super
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
    feature_counts
    

  generateChart: (sample) ->
    counts = @formatData sample.subject

    your_classification = key for key, value of sample.group_classification when value > 0

    switch your_classification
      when "smooth_count" then your_classification = 0
      when "disk_count" then your_classification = 1
      when "other_count" then your_classification = 2

    chart = nv.models.multiBarHorizontalChart()
      .x (d) ->
        d.label
      .y (d) ->
        d.value
      .showControls(false)
      .showLegend(false)
      .showValues(true)
      .tooltips(false)

    chart.multibar.valueFormat(d3.format(',.0f'))

    color = d3.scale.linear()
      .domain()
    data = [{
        key: 'Galaxy Features',
        values: counts
      }]


    d3.select('[data-id="' + sample.classification_id + '"] svg')
      .datum(data)
      .transition().duration(500)
      .call(chart)

    d3.selectAll('.nv-bar text').attr('dy','0.35em')
    
    # Not the correct way.
    d3.select('[data-id="' + sample.classification_id + '"] svg .nv-bar:nth-child(' + (your_classification + 1) + ') rect').style('fill','#ff9c00')
      .call(chart)

    nv.utils.windowResize(chart.update)

module.exports = MyGalaxies