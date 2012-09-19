Spine = require('spine')

class Interactive extends Spine.Controller
  events:
    'click input#dx-change': 'addDX'

  constructor: ->
    super
    @render()

  template: require('views/interactive/interactive')

  render: =>
    @html @template()

  addDX: ->
    if $("#dx-change").hasClass('unclicked')
      $("#dx-change").removeClass('unclicked').addClass('clicked')
      $('div#home').addClass('dx')
      $('#box').addClass('dx')
      $('h1').addClass('dx')
      $('h2').addClass('dx')
      $('p').addClass('dx')
      $('#link_buttons a').addClass('dx')
    else
      $("#dx-change").removeClass('clicked').addClass('unclicked')
      $('div#home').removeClass('dx')
      $('#box').removeClass('dx')
      $('h1').removeClass('dx')
      $('h2').removeClass('dx')
      $('p').removeClass('dx')
      $('#link_buttons a').removeClass('dx')

  createBarChart: ->
    data = [4, 8, 15, 16, 23, 42]
    chart = d3.select('galaxy_bar_chart').append("svg").attr("width", 420).attr("height", 20 * data.length)
    x = d3.scale.linear().domain([0, d3.max(data)]).range([0, 420])
    y = d3.scale.ordinal().domain(data).rangeBands([0, 120])
    chart.selectAll("rect").data(data).enter().append("rect").attr("y", (d, i) ->
      i * 20
    ).attr("width", x).attr "height", 20


module.exports = Interactive