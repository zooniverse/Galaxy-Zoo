Config = require 'lib/config'
Dialog = require 'lib/dialog'

Api = require 'zooniverse/lib/api'
User = require 'zooniverse/lib/models/user'
Subject = require 'zooniverse/lib/models/subject'

QuizQuestion = require 'models/quiz_question'

class Quiz extends Subject
  @configure 'Quiz', 'metadata', 'setIndex'
  projectName: 'galaxy_zoo_quiz'
  
  @workflowUrl: (params) -> @withParams "/projects/galaxy_zoo_quiz/workflows/#{ Config.quiz.workflowId }/classifications", params
  @url: (params) -> @withParams "/projects/galaxy_zoo_quiz/subjects", params
  
  @invitation: ->
    @invitationDialog or= new Dialog
      template: 'views/quiz/invitation'
      callback: @dialogCallback
    @invitationDialog.show()
  
  @reminder: ->
    @reminderDialog or= new Dialog
      template: 'views/quiz/reminder'
      callback: @dialogCallback
    @reminderDialog.show()
  
  @dialogCallback: (answer) =>
    Api.post @workflowUrl(),
      classification:
        subject_ids: [Config.quiz.invitationId]
        annotations: [{ response: answer }]
    
    @next() if answer is 'yes'
  
  @next: (opts = { }) ->
    @fetch().onSuccess (quizzes) =>
      quiz = quizzes[0]
      @current = @find quiz.id
      @current.show opts
  
  constructor: (hash) ->
    super
    Quiz.classificationCount or= 0
    @setIndex or= hash.index
    
    unless @questions
      @questions = []
      for question, index in @metadata.questions
        @questions.push new QuizQuestion(question, @setIndex, index)
    
    @results = []
    @index = 0
  
  question: =>
    @questions[@index]
  
  answers: =>
    @question().answers
  
  send: =>
    Api.post Quiz.workflowUrl(),
      classification:
        subject_ids: [@id]
        annotations: @results
  
  show: ({ @required } = { }) =>
    @required ?= true
    
    dialog = new Dialog
      template: 'views/quiz/question'
      buttonSelector: '.answer [data-dialog="true"]'
      closeButton: not @required
      callback: @callback
    
    dialog.show()
  
  finish: =>
    @send()
    Quiz.classificationCount += 1
    @trigger 'quiz-finished'
    dialog = new Dialog
      template: 'views/quiz/finish'
      callback: (answer) =>
        Quiz.next() if answer is 'now'
    
    dialog.show()
  
  callback: (answer) =>
    if answer
      @results.push question: @index, answer: answer
      @index += 1
      if @question() then @show(required: @required) else @finish()
    else
      @results = []
      @index = 0

module.exports = Quiz
