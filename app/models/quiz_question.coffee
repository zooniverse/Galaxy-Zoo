class QuizQuestion
  constructor: (hash) ->
    @text = hash.question.text
    @image = hash.question.image
    @answers = hash.answers
  
  answerLetters: =>
    start = 97
    end = start + @answers.length
    _([start ... end]).collect (i) -> String.fromCharCode(i)
  
  answersWithLetters: =>
    _({ }).tap (hash) =>
      for [letter, answer] in _(@answerLetters()).zip(@answers)
        hash[letter] = answer

module.exports = QuizQuestion
