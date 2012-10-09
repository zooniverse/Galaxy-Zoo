Spine = require 'spine'
Api = require 'zooniverse/lib/api'
User = require 'zooniverse/lib/models/user'
Quiz = require 'models/quiz'
LoginForm = require 'zooniverse/lib/controllers/login_form'

class Quizzer extends Spine.Controller
  constructor: ->
    super
    Quiz.bind 'quiz-user', @render
  
  active: ->
    super
    @render()
  
  render: =>
    return unless @isActive()
    
    if User.current
      @navigate '/'
      Quiz.reminder()
    else
      @html require('views/login')()
      new LoginForm el: '#login'

module.exports = Quizzer
