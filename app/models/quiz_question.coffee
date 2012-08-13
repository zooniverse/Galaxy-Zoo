Config = require 'lib/config'
Subject = require 'zooniverse/lib/models/subject'
Dialog = require 'lib/dialog'

class QuizQuestion extends Subject
  @configure 'QuizQuestion', 'question', 'answers'
  projectName: 'galaxy_zoo_quiz'
  
  @url: (params) -> @withParams "/projects/galaxy_zoo_quiz/subjects", params
  
  @next: ->
    @fetch().onSuccess =>
      @current = @first()
      @trigger 'fetched'
  
  show: (index = 0) ->
    new Dialog 'views/quiz_invitation', @callback
  
  callback: =>
    console.log 'callback', @, arguments

module.exports = QuizQuestion
