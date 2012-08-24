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

module.exports = Examine
