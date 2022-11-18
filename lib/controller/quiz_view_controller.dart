import 'package:queasy/model/question.dart';
import 'package:queasy/model/quiz.dart';
import 'package:queasy/model/user.dart';

/// This is the controller for [QuizView].
///
/// It is responsible for connecting the [QuizView] to the [Quiz], [User] and
/// [Question] models.
class QuizViewController {
  /// The [Quiz] that is currently being taken.
  late Quiz _quiz;

  /// The [User] that is currently taking the quiz.
  late Profile player;

  /// The category of the quiz.
  //TODO
  final String _category = 'Science';

  /// A list with the [Question]s in this quiz.
  late List<Question> _questions;

  /// The number of questions in the quiz.
  late final int _totalQuestions;

  /// The index of the question that is currently being answered.
  int _currentQuestionIndex = 0;

  /// The number of points the user has earned so far.
  int _currentPoints = 0;

  /// Constructor for [QuizViewController]. It initializes the [Quiz].
  QuizViewController() {
    initQuiz();
  }

  /// Initializes the [Quiz] and the [Question]s.
  ///
  /// It creates a Quiz with a certain number of questions and initializes
  /// the list of questions with the questions from the quiz.
  void initQuiz() {
    _quiz = Quiz.normal(
      id: 1,
      noOfQuestions: 5,
      category: 'Science',
    );
    _questions = _quiz.getQuestions();
    _totalQuestions = _questions.length;
  }

  /// Getter for category
  String get category => _category;

  /// Getter for the current points.
  int get points => _currentPoints;

  /// Getter for the current question index.
  int get currentQuestionIndex => _currentQuestionIndex;

  /// Getter for the total number of questions.
  int get totalQuestions => _totalQuestions;

  /// Getter for the current question text.
  String getQuestionText() {
    return _questions[_currentQuestionIndex].getText();
  }

  /// Getter for the answer text. It takes an [index] as parameter to decide
  /// which answer text to return.
  String getAnswerText(int index) {
    return _questions[_currentQuestionIndex].getAnswer(index).getText();
  }

  /// Getter for [isCorrect] of the answer. It takes an [index] as parameter to
  /// decide which answer to check.
  bool isCorrectAnswer(int answerIndex) {
    return _questions[_currentQuestionIndex].getAnswer(answerIndex).isCorrect();
  }

  /// Updates the question index, showing the next question in the list. If
  /// there is no more questions, it updates the score of the player with
  /// the current points. Returns `true` if there is a next question, `false`
  /// if the current question is the last one.
  bool nextQuestion() {
    if (_currentQuestionIndex < _totalQuestions - 1) {
      _currentQuestionIndex++;
      return true;
    } else {
      //TODO edit username and category to be functional from Firebase
      player.updateScore("Savo", _category, _currentPoints);
      return false;
    }
  }

  /// Edits the current score of the user. Takes [isCorrect] as parameter to
  /// decide how to edit the score. In case the answer is correct, it adds 5
  /// points to the current score. In case the answer is incorrect, it subtracts
  /// 1 points from the current score. Current score can never be less than 0.
  void editScore(bool isCorrect) {
    _currentPoints = isCorrect ? _currentPoints + 5 : _currentPoints - 1;
    if (_currentPoints < 0) {
      _currentPoints = 0;
    }
  }
}
