Spine = require('spine')

class Interactive extends Spine.Controller
  el: require('views/interactive/interactive')() 

  events:
    'click .navigator_home': 'linkToNavigatorHome'
    'click .classify_galaxies': 'linkToGalaxyZoo'
    'click .my_galaxies': 'linkToMyGalaxies'
    'click .graph': 'linkToGraph'
    'click input#dx-change': 'addDX'
    #'click .galaxy_img': 'createBarChart'

  elements:
    '.navigator_home': 'navigatorHomeText'

  constructor: ->
    super

  linkToNavigatorHome: (ev) ->
    home = require('views/interactive/home')
    @navigatorHomeText.html 'Choose Your Investigation'
    $('#main_body').replaceWith(home)
    ev.preventDefault()
    
  linkToGalaxyZoo: (ev) ->
    @navigate '/classify'

  linkToMyGalaxies: (ev) ->    
    my_gals = require('views/interactive/my_galaxies')
    @navigatorHomeText.html 'My Galaxies'
    $('#main_body').replaceWith(my_gals)
    if $("#dx-change").hasClass('clicked')
      $('h2').addClass('dx')
    ev.preventDefault()
    
  linkToGraph: (ev) ->
    graph = require('views/interactive/graph')
    @navigatorHomeText.html 'Graphing Galaxy Data'
    $('#main_body').replaceWith(graph)
    if $("#dx-change").hasClass('clicked')
      $('h2').addClass('dx')
    ev.preventDefault()      

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