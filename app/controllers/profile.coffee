Spine = require 'spine'

class Profile extends Spine.Controller
  constructor: ->
    super
  
  active: ->
    super
    @render()
  
  render: ->
    @html require('views/profile')(@)

module.exports = Profile
