Spine = require 'spine'

class Navigation extends Spine.Controller
  el: 'html'
  events:
    'click a[data-nav]': 'navTo'
  
  constructor: ->
    super
  
  navTo: ({ originalEvent: e }) ->
    path = $(e.target).closest('a').data 'nav'
    e.preventDefault()
    @navigate(path)
    $('html,body').animate({ scrollTop: $('#main').offset().top }, 'fast')
  
  active: ->
    super
    @render()
  
  render: ->
    $('#navigation').html require('views/navigation')(@)

module.exports = Navigation
