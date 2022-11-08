import 'package:queasy/model/question.dart';
import 'package:queasy/model/quiz.dart';

class QuizViewController {
  late Quiz _quiz;
  int _currentQuestionIndex = 0;
  final int _totalQuestions = 10;
  late List<Question> _questions;
  final String _category = 'Science';
  int _currentScore = 0;

  QuizViewController() {
    initQuiz();
  }

  void initQuiz() {
    _quiz = Quiz(
      id: 1,
      noOfQuestions: 5,
      category: 'Science',
    );
    _questions = _quiz.getQuestions();
  }

  Quiz get quiz => _quiz;
  String get category => _category;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get totalQuestions => _totalQuestions;
  List<Question> get questions => _questions;
  int get totalPoints => _currentScore;

  String getQuestionText() {
    return _questions[_currentQuestionIndex].getText();
  }

  String getAnswerText(int index) {
    return _questions[_currentQuestionIndex].getAnswer(index).getText();
  }

  bool nextQuestion() {
    if (_currentQuestionIndex < _totalQuestions - 1) {
      _currentQuestionIndex++;
      return true;
    } else {
      _quiz.updateScore("Savo", _currentScore);
      return false;
    }
  }

  bool isCorrectAnswer(int answerIndex) {
    return _questions[_currentQuestionIndex].getAnswer(answerIndex).isCorrect();
  }

  /// If the answer is correct, the score is incremented by 100
  /// @param answer The answer that was selected
  void editScore(int answerIndex) {
    bool isCorrect =
        _questions[_currentQuestionIndex].getAnswer(answerIndex).isCorrect();
    print(isCorrect);
    _currentScore = isCorrect ? _currentScore + 5 : _currentScore - 1;
    if (_currentScore < 0) {
      _currentScore = 0;
    }
  }
}
