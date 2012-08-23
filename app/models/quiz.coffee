Config = require 'lib/config'
Dialog = require 'lib/dialog'

Api = require 'zooniverse/lib/api'
User = require 'zooniverse/lib/models/user'
Subject = require 'zooniverse/lib/models/subject'

QuizQuestion = require 'models/quiz_question'

class Quiz extends Subject
  @configure 'Quiz', 'metadata'
  projectName: 'galaxy_zoo_quiz'
  
  @workflowUrl: (params) -> @withParams "/projects/galaxy_zoo_quiz/workflows/#{ Config.quiz.workflowId }/classifications", params
  @url: (params) -> @withParams "/projects/galaxy_zoo_quiz/subjects", params
  
  @invitation: ->
    @invitationDialog or= new Dialog
      template: 'views/quiz_invitation'
      callback: @dialogCallback
    @invitationDialog.show()
  
  @reminder: ->
    @reminderDialog or= new Dialog
      template: 'views/quiz_reminder'
      callback: @dialogCallback
    @reminderDialog.show()
  
  @dialogCallback: (answer) =>
    Api.post @workflowUrl(),
      classification:
        subject_ids: [Config.quiz.invitationId]
        annotations: [{ response: answer }]
    
    @next() if answer is 'yes'
  
  @next: ->
    @fetch().onSuccess =>
      @current?.destroy()
      @current = @first()
      @current.show()
  
  constructor: ->
    super
    Quiz.classificationCount or= 0
    @questions or= _(@metadata.questions).collect (question) -> new QuizQuestion(question)
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
  
  show: =>
    dialog = new Dialog
      template: 'views/quiz_question'
      buttonSelector: '.answer [data-dialog="true"]'
      callback: @callback
    
    dialog.show()
  
  finish: =>
    @send()
    Quiz.classificationCount += 1
    dialog = new Dialog
      template: 'views/quiz_finish'
      callback: (answer) =>
        Quiz.next() if answer is 'now'
    
    dialog.show()
  
  callback: (answer) =>
    @results.push question: @index, answer: answer
    @index += 1
    if @question() then @show() else @finish()

module.exports = Quiz
