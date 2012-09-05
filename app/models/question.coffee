Spine = require 'spine'

class Question extends Spine.Model
  @configure 'Question', 'tree', 'title', 'text', 'helpText', 'answers', 'checkboxes', 'leadsTo'
  
  @findByTreeAndText: (tree, text) ->
    @select (q) -> q.tree is tree and q.text is text
  
  @firstForTree: (tree) ->
    @find "#{ tree }-0"
  
  constructor: (hash) ->
    count = Question.findAllByAttribute('tree', hash.tree).length
    @id or= "#{ hash.tree }-#{ count }"
    @helpText or= ''
    @answers or= { }
    @checkboxes or= { }
    hash.answerWith?.apply @
    super
  
  help: (text) ->
    @helpText = text
  
  answer: (text, { leadsTo: leadsTo, icon: icon, examples: examples } = { leadsTo: null, icon: null, examples: 0 }) ->
    @answers["a-#{ _(@answers).keys().length }"] = { text, leadsTo, icon, examples }
  
  examples: =>
    _({ }).tap (examples) =>
      for key, answer of @answers
        _(answer.examples).times (i) =>
          examples[key] or= []
          examples[key].push "#{ @id }_#{ key }_#{ i }"
  
  checkbox: (text, { icon: icon } = { icon: null }) ->
    checkbox = true
    @checkboxes["x-#{ _(@checkboxes).keys().length }"] = { checkbox, text, icon }
  
  nextQuestionFrom: (answer) ->
    text = @answers[answer]?.leadsTo or @leadsTo
    question = @constructor.findByTreeAndText @tree, text
    question[0] or null

module.exports = Question
