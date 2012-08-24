Spine = require 'spine'
Subject = require 'models/subject'
User = require 'zooniverse/lib/models/user'
Api = require 'zooniverse/lib/api'

class Examine extends Spine.Controller
  constructor: ->
    super
    User.bind 'sign-in', @refresh
  
  active: (params) ->
    super
    @id = params.id
    @refresh()
    @render()
  
  refresh: =>
    return unless User.current and @isActive() and @id
    fetcher = Subject.show @id
    fetcher.onSuccess (json) => @subject = new Subject(json)
    fetcher.onSuccess @render
  
  render: =>
    @html require('views/examine/examine')(@)
  
  info: (key, values...) =>
    value = values.shift()
    return unless value
    
    """
      <div class="row">
        <span class="key">#{ key }:</span>
        <span class="value">#{ value } #{ values.join(' ') }</span>
      </div>
    """

module.exports = Examine
