Spine = require 'spine'
Api = require 'zooniverse/lib/api'
User = require 'zooniverse/lib/models/user'
Quiz = require 'models/quiz'
Classification = require 'models/classification'

class Quizzes extends Spine.Controller
  constructor: ->
    super
    @classificationCount = 0
    
    User.bind 'sign-in', @check
    Classification.bind 'classified', =>
      if User.current
        @classificationCount += 1
        @check()
  
  check: =>
    return unless User.current
    checker = Api.getJSON "/projects/galaxy_zoo_quiz/current_user"
    checker.onSuccess (user) =>
      Quiz.user = user
      Quiz.classificationCount = user.project?.classification_count or 0
      Quiz.trigger 'quiz-user'
    
    checker.onSuccess(@triggerQuizzesFor) if @classificationCount is 5
  
  triggerQuizzesFor: (user) =>
    answer = user.project.invitation?.response
    lastInvite = user.project.invitation?.timestamp
    lastActive = user.project.last_active_at
    
    return unless Quiz.classificationCount < 6
    Quiz.invitation() if answer is undefined or (answer is 'later' and @aWeekSince(lastInvite))
    Quiz.reminder() if answer is 'yes' and @aWeekSince(lastActive)
  
  aWeekSince: (timestamp) ->
    return false unless timestamp
    lastTime = new Date(timestamp).getTime()
    aWeek = 7 * 24 * 60 * 60 * 1000
    timeSince = new Date().getTime() - lastTime
    timeSince > aWeek

module.exports = Quizzes
