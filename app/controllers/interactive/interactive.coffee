Spine = require('spine')

class Interactive extends Spine.Controller
  el: require('views/interactive/interactive')() 

  events:
    'click .navigator_home': 'linkToNavigatorHome'
    'click .classify_galaxies': 'linkToGalaxyZoo'
    'click .my_galaxies': 'linkToMyGalaxies'
    'click .graph': 'linkToGraph'
    'click input#dx-change': 'addDX'

  constructor: ->
    super

  linkToNavigatorHome: (ev) ->
    home = require('views/interactive/home')
    $('#main_body').replaceWith(home)
    ev.preventDefault()
    
  linkToGalaxyZoo: (ev) ->
    @navigate '/classify'

  linkToMyGalaxies: (ev) ->    
    my_gals = require('views/interactive/my_galaxies')
    $('#main_body').replaceWith(my_gals)
    if $("#dx-change").hasClass('clicked')
      $('h2').addClass('dx')
    ev.preventDefault()
    
  linkToGraph: (ev) ->
    graph = require('views/interactive/graph')
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

 

module.exports = Interactive