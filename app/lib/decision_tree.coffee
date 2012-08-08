Question = require 'models/question'
_ = require 'underscore/underscore'

class DecisionTree
  constructor: (@name, tree) -> tree.apply @
  first: -> Question.firstForTree @name
  
  question: (args...) ->
    args = @extractArgsFrom args
    Question.create args
  
  extractArgsFrom: (args) ->
    if typeof args[1] == 'function'
      tree: @name
      text: args[0]
      leadsTo: null
      answerWith: args[1]
    else
      tree: @name
      text: args[0]
      leadsTo: args[1].leadsTo
      answerWith: args[2]

module.exports = DecisionTree
