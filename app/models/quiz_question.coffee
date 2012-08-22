Config = require 'lib/config'
Dialog = require 'lib/dialog'

Api = require 'zooniverse/lib/api'
User = require 'zooniverse/lib/models/user'
Subject = require 'zooniverse/lib/models/subject'

class QuizQuestion extends Subject
  @configure 'QuizQuestion', 'metadata'
  projectName: 'galaxy_zoo_quiz'
  
  @url: (params) -> @withParams "/projects/galaxy_zoo_quiz/subjects", params
  
  @invitation: ->
    @invitationDialog or= new Dialog
      template: 'views/quiz_invitation'
      callback: (answer) =>
        Api.post "/projects/galaxy_zoo_quiz/workflows/#{ Config.quiz.workflowId }/classifications",
          classification:
            subject_ids: [Config.quiz.invitationId]
            annotations: [{ response: answer }]
        
        switch answer
          when 'yes'
            QuizQuestion.next()
    
    @invitationDialog.show()
  
  @next: ->
    @fetch().onSuccess =>
      @current?.destroy()
      @current = @first()
      @current.show()
  
  constructor: ->
    super
    @index = 0
  
  question: =>
    @metadata.questions[@index].question
  
  answers: =>
    @metadata.questions[@index].answers
  
  show: =>
    @dialog or= new Dialog
      template: 'views/quiz_question'
      closeButton: true
      callback: (answer) =>
        console.log answer
    
    @dialog.show()
  
  callback: =>
    @index += 1

module.exports = QuizQuestion
