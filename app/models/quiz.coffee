Config = require 'lib/config'
Dialog = require 'lib/dialog'

Api = require 'zooniverse/lib/api'
User = require 'zooniverse/lib/models/user'
Subject = require 'zooniverse/lib/models/subject'

QuizQuestion = require 'models/quiz_question'

class Quiz extends Subject
  @configure 'Quiz', 'metadata'
  projectName: 'galaxy_zoo_quiz'
  
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
    Api.post "/projects/galaxy_zoo_quiz/workflows/#{ Config.quiz.workflowId }/classifications",
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
    @questions or= _(@metadata.questions).collect (question) -> new QuizQuestion(question)
    @index = 0
  
  question: =>
    @questions[@index]
  
  answers: =>
    @question().answers
  
  show: =>
    dialog = new Dialog
      template: 'views/quiz_question'
      buttonSelector: '.answer [data-dialog="true"]'
      callback: @callback
    
    dialog.show()
  
  finish: =>
    dialog = new Dialog
      template: 'views/quiz_finish'
    dialog.show()
  
  callback: (answer) =>
    # console.log 'record: ', { question: @index, answer: answer }
    @index += 1
    if @question() then @show() else @finish()

module.exports = Quiz
