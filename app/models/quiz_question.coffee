class QuizQuestion
  constructor: (hash, quizIndex, questionIndex) ->
    @text = hash.question.text
    @text = I18n.t 'quiz_questions', "set_#{ quizIndex }", "question_#{ questionIndex }", 'text'
    @image = hash.question.image
    @answers = []
    
    for answer, index in hash.answers
      answer.text = I18n.t 'quiz_questions', "set_#{ quizIndex }", "question_#{ questionIndex }", "answer_#{ index }"
      @answers.push answer
  
  answerLetters: =>
    start = 97
    end = start + @answers.length
    _([start ... end]).collect (i) -> String.fromCharCode(i)
  
  answersWithLetters: =>
    _({ }).tap (hash) =>
      for [letter, answer] in _(@answerLetters()).zip(@answers)
        hash[letter] = answer

module.exports = QuizQuestion
