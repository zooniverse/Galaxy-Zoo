$ = require 'jqueryify'

class Dialog
  constructor: ({ template, @callback, @quickHide }) ->
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
  
  show: ->
    if @el()[0]
      @el().addClass 'open'
    else
      @render()
  
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
    if @quickHide
      @el().live 'click', (ev) =>
        if ev.target is @el()[0]
          @callback? null
          @close()
          ev.preventDefault()
    
    @buttons().live 'click', @clicked

module.exports = Dialog
