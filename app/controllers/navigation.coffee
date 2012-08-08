Spine = require 'spine'

class Navigation extends Spine.Controller
  el: '#navigation'
  events:
    'click nav a': 'navTo'
  
  constructor: ->
    super
  
  navTo: ({ originalEvent: e }) ->
    path = $(e.target).closest('a').data 'nav'
    e.preventDefault()
    @navigate path
  
  active: ->
    super
    @render()
  
  render: ->
    @html require('views/navigation')(@)

module.exports = Navigation
