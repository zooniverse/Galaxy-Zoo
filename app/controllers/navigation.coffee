Spine = require 'spine'

class Navigation extends Spine.Controller
  el: 'html'
  events:
    'click [data-nav]': 'navTo'
  
  constructor: ->
    super
  
  navTo: (ev) ->
    path = $(ev.target).closest('[data-nav]').data 'nav'
    ev.preventDefault()
    @navigate path
    $('html,body').animate { scrollTop: $('#main').offset().top }, 'fast'
  
  active: ->
    super
    @render()
  
  render: ->
    $('#navigation').html require('views/navigation')(@)

module.exports = Navigation
