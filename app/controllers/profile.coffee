Spine = require 'spine'
User = require 'zooniverse/lib/models/user'
Recent = require 'zooniverse/lib/models/recent'

class Profile extends Spine.Controller
  elements:
    '.thumbnails': 'thumbnails'

  constructor: ->
    super
    User.bind 'sign-in', @setUser
    Recent.bind 'create', @displayThumbnails
  
  setUser: =>
    @user = User.current
    Recent.destroyAll()
    Recent.fetch()
    @render()
  
  render: ->
    @html require('views/profile')(@)

  renderLogin: ->

  displayThumbnails: (recent) =>
    @thumbnails.append """
      <div class="thumb"><img src="#{recent.subjects.location.thumbnail}" height="140" width="140" /></div>
    """

module.exports = Profile
