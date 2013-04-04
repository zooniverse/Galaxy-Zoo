Spine = require 'spine'

class Science extends Spine.Controller
  constructor: ->
    super
    @render()  
    

  active: ->
    super
    
  render: ->
    @html require('views/science')(@)

module.exports = Science
