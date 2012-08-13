Spine = require 'spine'
User = require 'zooniverse/lib/models/user'

class Profile extends Spine.Controller
  constructor: ->
    super
  
  user: -> User.current
  
  active: ->
    super
    @render() if @user()
  
  render: ->
    @html require('views/profile')(@)

module.exports = Profile
