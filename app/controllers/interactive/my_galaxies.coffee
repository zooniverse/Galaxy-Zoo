Spine = require('spine')
Sample = require 'lib/sample_interactive_data'
Dialog = require 'lib/dialog'

SubjectViewer = require 'ubret/lib/controllers/SubjectViewer'
BaseController = require 'ubret/lib/controllers/BaseController'

class MyGalaxies extends Spine.Controller

  events:
    'click .subject': 'popupViewer'

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

  formatData: (sample) ->
    feature_counts = []
    nice_key = ''
    your_classification = key for key, value of sample.group_classification when value > 0

    for key, value of sample.subject

      switch key
        when "smooth_count" then nice_key = "Smooth"
        when "disk_count" then nice_key = "Disk"
        when "other_count" then nice_key = "Other"

      if your_classification == key
        selected = true
      else
        selected = false

      feature_counts.push {
          'key': key,
          'label': nice_key,
          'value': value,
          'selected': selected
        }

    feature_counts

  generateChart: (sample) ->
    counts = @formatData sample

    data = {
        key: 'Galaxy Features',
        values: counts
      }

    chart = d3.select('[data-id="' + sample.classification_id + '"] svg')
      .append('g')
      .attr('width', 265)
      .attr('height', 100)

    x = d3.scale.linear()
      .domain([0, d3.max(data.values, (d) -> d.value)])
      .range([1, 150])

    color = d3.scale.ordinal()
      .range(['#1e7797', '#ff9c00'])

    chart.selectAll('rect')
      .data(data.values)
      .enter().append('rect')
      .attr('y', ((d,i) -> i * 22))
      .attr('x', 55)
      .attr('height', 20)
      .style('fill', ((d, i) ->
          if d.selected
            '#ff9c00'
          else
            '#1e7797'
        ))
      .on("mouseover", ((d) ->
          d3.select(@).classed('hovered', true)
        ))
      .on("mouseout", ((d) ->
          d3.select(@).classed('hovered', false)
        ))
      .transition().duration(500)
      .attr('width', ((d) -> x d.value))


    chart.selectAll('text.label')
      .data(data.values).enter()
      .append('text')
      .attr('class','label')
      .attr('y', ((d,i) -> i * 22))
      .attr('x', 45)
      .attr('dy', '1.3em')
      .attr('text-anchor', 'end')
      .text((d, i) -> d.label)

    chart.selectAll('text.value')
      .data(data.values).enter()
      .append('text')
      .attr('class','value')
      .attr('y', ((d,i) -> i * 22))
      .attr('x', ((d) -> x d.value))
      .attr('dx', 59)
      .attr('dy', '1.25em')
      .text((d) -> d.value)

  popupViewer: (e) ->
    galaxy_id = $(e.currentTarget).parents('.galaxy').data('id')

    data = []
    subject = _.find @samples, (sample) => sample.classification_id == galaxy_id
    data.push subject

    console.log 'Galaxy ID: ', galaxy_id
    console.log 'Data: ', data

    subject_viewer = new SubjectViewer({el: '.dialog-content'})
    subject_viewer.receiveData data

    $('.dialog-underlay').show()
    $('.dialog-underlay').click ->
      $(@).hide()

    console.log 'Subject Viewer', subject_viewer



module.exports = MyGalaxies