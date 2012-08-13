$ = require 'jqueryify'

class Dialog
  constructor: (template, @callback) ->
    @id = _.uniqueId 'dialog-'
    @template = require template
    @unbind()
    @bind()
  
  el: ->
    $ "##{ @id }"
  
  render: ->
    $('body').append require('views/dialog')(@)
  
  close: ->
    @el().removeClass 'open'
  
  buttons: ->
    $ 'button[data-dialog="true"]', @el()
  
  unbind: ->
    @el().die 'click'
    @buttons().die 'click'
  
  clicked: (ev) =>
    @callback? $(ev.target).data('value')
    @close()
    ev.preventDefault()
  
  bind: ->
    @buttons().live 'click', @clicked

module.exports = Dialog
