Spine = require('spine')
Sample = require 'lib/sample_interactive_data'
Dialog = require 'zooniverse/lib/dialog'
User = require 'zooniverse/lib/models/user'

SubjectViewer = require 'ubret/lib/controllers/SubjectViewer'
BaseController = require 'ubret/lib/controllers/BaseController'
InteractiveSubject = require 'ubret/lib/models/InteractiveSubject'

class MyGalaxies extends Spine.Controller

  events:
    'click .galaxy': 'popupViewer'

  constructor: ->
    super
    @headingText = $('#heading_text')
    @action_title = '<h2>My Galaxies</h2>'

    User.bind 'sign-in', =>
      if User.current?.user_group_id
        InteractiveSubject.fetch({limit: 10, user: true}).onSuccess =>
          @samples = InteractiveSubject.lastFetch

  active: ->
    super
    if (typeof(User.current.user_group_id) is 'undefined') and (typeof(@sample) is 'undefined')
      InteractiveSubject.fetch({limit: 10, user: true}).onSuccess =>
        @samples = InteractiveSubject.lastFetch
        @render()
    else
      @render()
    @headingText.html @action_title
    $('[data-link="my_galaxies"]').addClass 'pressed'

  deactivate: ->
    super
    @headingText.html ''
    $('[data-link="my_galaxies"]').removeClass 'pressed'

  render: ->
    @html require('views/interactive/my_galaxies')(@)
    if @samples
      for sample in @samples
        @generateChart sample

  formatData: (sample) ->
    feature_counts = []
    nice_key = ''
    your_classification = sample.classification

    for key, value of sample.counters

      switch key
        when "smooth" then nice_key = "Smooth"
        when "feature" then nice_key = "Features or disk"
        when "star" then nice_key = "Star or artifact"

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

    chart = d3.select('[data-id="' + sample.zooniverse_id+ '"] svg')
      .append('g')
      .attr('width', 265)
      .attr('height', 100)

    x = d3.scale.linear()
      .domain([0, d3.max(data.values, (d) -> d.value)])
      .range([1, 120])

    color = d3.scale.ordinal()
      .range(['#1e7797', '#ff9c00'])

    chart.selectAll('rect')
      .data(data.values)
      .enter().append('rect')
      .attr('y', ((d,i) -> i * 22))
      .attr('x', 85)
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
      .attr('x', 80)
      .attr('dx', 44)
      .attr('dy', '1.3em')
      .attr('text-anchor', 'end')
      .text((d, i) -> d.label)

    chart.selectAll('text.value')
      .data(data.values).enter()
      .append('text')
      .attr('class','value')
      .attr('y', ((d,i) -> i * 22))
      .attr('x', ((d) -> x d.value))
      .attr('dx', 89)
      .attr('dy', '1.25em')
      .text((d) -> d.value)

  popupViewer: (e) =>
    galaxy_id = $(e.currentTarget).data('id')

    data = []
    subject = _.find @samples, (sample) => 
      sample.zooniverse_id == galaxy_id
    data.push subject

    d = new Dialog
    d.open()

    subject_viewer = new SubjectViewer({el: '.dialog-content'})
    subject_viewer.receiveData data

module.exports = MyGalaxies