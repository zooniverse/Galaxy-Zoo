Spine = require 'spine'
Api = require 'zooniverse/lib/api'
User = require 'zooniverse/lib/models/user'
QuizQuestion = require 'models/quiz_question'
Classification = require 'models/classification'

class Quiz extends Spine.Controller
  constructor: ->
    super
    @classificationCount = 0
    
    User.bind 'sign-in', @check
    Classification.bind 'classified', =>
      @classificationCount += 1
      @check()
  
  check: =>
    return unless User.current and @classificationCount is 5
    Api.getJSON "/projects/galaxy_zoo_quiz/current_user", (user) =>
      answer = user.project.invitation?.response
      timestamp = user.project.invitation?.timestamp
      
      isTime = if timestamp
        lastTime = new Date(timestamp).getTime()
        aWeek = 7 * 24 * 60 * 60 * 1000
        timeSince = new Date().getTime() - lastTime
        timeSince > aWeek
      else
        false
      
      QuizQuestion.invitation() if answer is undefined or (answer is 'later' and isTime)
  
  render: ->

module.exports = Quiz
