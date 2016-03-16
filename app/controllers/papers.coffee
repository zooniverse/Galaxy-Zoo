{ Controller } = require 'spine'

class Papers extends Controller

  active: ->
    super
    @render()
  
  render: ->
    window.location = 'https://www.zooniverse.org/publications?project=hubble'

module.exports = Papers
