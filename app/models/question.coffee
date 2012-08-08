Spine = require 'spine'
_ = require 'underscore/underscore'

class Question extends Spine.Model
  @configure 'Question', 'tree', 'text', 'answers', 'leadsTo'
  
  constructor: (hash) ->
    count = Question.findAllByAttribute('tree', hash.tree).length
    @id or= "#{ hash.tree }-#{ count }"
    @answers or= { }
    hash.answerWith?.apply @
    super
  
  answer: (text, { leadsTo: leadsTo } = { leadsTo: null }) ->
    @answers["a-#{ _(@answers).keys().length }"] =
      text: text
      leadsTo: leadsTo
  
  nextQuestionFrom: (answer) ->
    text = @answers[answer]?.leadsTo or @leadsTo
    question = Question.select (question) =>
      question.tree is @tree and question.text is text
    question[0] or null
  
module.exports = Question
