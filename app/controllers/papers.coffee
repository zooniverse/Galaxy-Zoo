{ Controller } = require 'spine'

class Papers extends Controller

  active: ->
    super
    @render()
  
  render: ->
    window.location = 'http://www.zooniverse.org/publications?project=hubble'

module.exports = Papers
