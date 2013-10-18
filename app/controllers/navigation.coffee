Spine = require 'spine'

class Navigation extends Spine.Controller
  el: 'html'
  events:
    'click [data-nav]': 'navTo'
    'click [data-lang-switch]': 'switchLang'
  
  constructor: ->
    super
  
  navTo: (ev) ->
    path = $(ev.target).closest('[data-nav]').data 'nav'
    ev.preventDefault()
    @navigate path
    $('html,body').animate { scrollTop: $('#main').offset().top }, 'fast'
  
  switchLang: (ev) ->
    ev.preventDefault()
    lang = $(ev.target).attr 'data-lang-switch'
    params = require 'lib/params'
    params.lang = lang
    query = ("#{ key }=#{ val }" for own key, val of params).join '&'
    window.location = "?#{ query }#{ document.location.hash }"
  
  active: ->
    super
    @render()
  
  render: ->
    $('#navigation').html require('views/navigation')(@)

module.exports = Navigation
