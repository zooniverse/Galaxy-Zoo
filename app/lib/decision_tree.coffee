Question = require 'models/question'
_ = require 'underscore/underscore'

class DecisionTree
  constructor: (@name, tree) -> tree.apply @
  
  question: (args...) ->
    args = @extractArgsFrom args
    Question.create args
  
  extractArgsFrom: (args) ->
    if typeof args[2] == 'function'
      tree: @name
      id: args[0]
      text: args[1]
      leadsTo: null
      answerWith: args[2]
    else
      tree: @name
      id: args[0]
      text: args[1]
      leadsTo: args[2].leadsTo
      answerWith: args[3]

module.exports = DecisionTree
