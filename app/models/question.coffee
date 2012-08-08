Spine = require 'spine'

class Question extends Spine.Model
  @configure 'Question', 'tree', 'text', 'answers', 'leadsTo'
  
  constructor: (hash) ->
    @answers or= { }
    hash.answerWith?.apply @
    super
  
  answer: (id, text, { leadsTo: leadsTo } = { leadsTo: null }) ->
    @answers[id] =
      text: text
      leadsTo: leadsTo
  
  nextQuestionFrom: (answerId) ->
    answer = @answers[answerId]
    Question.select (question) =>
      question.tree is @tree and question.text is answer.leadsTo
  
module.exports = Question
