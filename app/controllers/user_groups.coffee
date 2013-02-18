Spine = require 'spine'
UserGroup = require 'models/user_group'
Api = require 'zooniverse/lib/api'
User = require 'zooniverse/lib/models/user'
Quiz = require 'models/quiz'
LoginForm = require 'zooniverse/lib/controllers/login_form'

class UserGroups extends Spine.Controller
  constructor: ->
    super
    User.bind 'sign-in', @render
    User.bind 'sign-in', UserGroup.fetchCurrent
    Quiz.bind 'quiz-user', @render
  
  active: (params) ->
    super
    UserGroup.groupName = params.id
    @render()
  
  render: =>
    return unless @isActive()
    
    if User.current and Quiz.user
      return unless UserGroup.groupName
      fetcher = UserGroup.join()
      fetcher.onSuccess => @navigate '/classify'
    else
      @html require('views/login')()
      new LoginForm el: '#login'

module.exports = UserGroups
