Spine = require 'spine'

class Navigation extends Spine.Controller
  el: 'html'

  elements:
    '[data-nav]' : 'navItem'
  
  events:
    'tap [data-nav]': 'navTo'
  
  constructor: ->
    super
  
    Spine.Route.bind 'change', =>
      $('html, body').css { "scrollTop" : "400px" }#, 800)

  
  navTo: (ev) ->
    $("ul li").removeClass('active')
    $(ev.currentTarget).addClass('active')
    path = $(ev.target).closest('[data-nav]').data 'nav'
    ev.preventDefault()
    @navigate path
 
  active: ->
    super
    @render()
  
  render: ->
    $('#navigation').html require('views/navigation')(@)

module.exports = Navigation
