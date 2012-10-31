Spine = require('spine')
User = require 'zooniverse/lib/models/user'
UserGroup = require 'models/user_group'
LoginForm = require 'zooniverse/lib/controllers/login_form'

class Interactive extends Spine.Controller
  events:
    'click input#dx-change': 'addDX'
    'click a.check-participate' : 'linkCheck'

  constructor: ->
    super
    @headingText = $('#heading_text')
    @action_title = require('views/interactive/partials/intro_text')(@)
    User.bind 'sign-in', @render

  render: =>
    @headingText.html @action_title
    @html require('views/interactive/interactive')(@)

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

  linkCheck: (e) =>
    if UserGroup.current
      return
    else
      e.preventDefault()
      alert('Select a group or create one from the dropdown menu to see your group classifications')


module.exports = Interactive