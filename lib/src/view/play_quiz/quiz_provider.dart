import 'dart:async';
import 'package:flutter/material.dart';
import 'package:queasy/main.dart';
import 'package:queasy/src/model/category.dart';
import 'package:queasy/src/model/statistics.dart';
import 'package:queasy/src/view/statistics/statistics_view.dart';
import '../../../utils/exceptions.dart';
import '../../model/profile.dart';
import '../../model/quiz.dart';

/// This class is responsible for managing the state of the quiz. It sums the
/// controller and the model for the use case of playing the quiz.
///
///The field [correctAnswers] counts the correct answers of the users
///
/// The late parameter [_quiz] is the quiz that is being played. It is
/// initialized in the method [startQuiz].
///
/// The parameter [player] is the player that is playing the quiz.
///
/// The late parameter [_category] is the category of the quiz. It is
/// initialized in the method [startQuiz].
///
/// The late parameter [_totalQuestions] is the total number of questions in the
/// quiz. It is initialized in the method [startQuiz].
///
/// The parameter [_currentQuestionIndex] is the index for the question that is
/// being displayed. It is initialized to 0 and incremented every time the user
/// clicks an answer button.
///
/// The parameter [_currentPoints] is the number of points the user has earned
/// so far. It is initialized to 0 and incremented every time the user answers a
/// question correctly.
///
/// The parameter [_currentQuestionAnswered] is a flag to avoid the user from
/// answering the same question twice. It is initialized to false and set to
/// true once the user clicks an answer button. It is set to false again when
/// the next question is displayed.
///
/// The parameter [countdownTimer] is the timer that counts down the time the
/// user has to answer a question. It is initialized to 15 seconds and is
/// decremented every second. It gets reset to 15 seconds for every new
/// question.
///
/// The parameter [_timeLeft] is the time left for the user to answer the
/// question. It is initialized to 15 seconds and is decremented every second.
/// It gets reset to 15 seconds for every new question. It is used to display
/// the time left in the UI. It is also used to calculate the score.
class QuizProvider with ChangeNotifier {
  // QuizProvider._internal();

  // static final QuizProvider _instance = QuizProvider._internal();
  //


  late Quiz _quiz;

  late Profile player;
  late String _category;
  late int _totalQuestions;
  int _currentQuestionIndex = 0;
  int _currentPoints = 0;
  int correctAnswers = 0;
  bool _currentQuestionAnswered = false;
  static Timer? countdownTimer;
  static Duration _timeLeft = const Duration(seconds: 15);
  int counter = 0;
  get category => _category;

  get quiz => _quiz;

  get timeLeft => _timeLeft.inSeconds.toString();


// assign the current user to the app
  QuizProvider() {
    // default profile
    player = Profile(
      username: 'Savo',
      email: 'savo@email.com',
      hashPassword: '1234',
    );
    init();
  }

  //player = Profile.getProfilefromUID(getCurrentUserID());
  /// initializes [player] as the current logged in user
  void init() async {
    String? uid = getCurrentUserID();
    Profile? p;
    if (uid != null) {
      // very important class method creating Profile instance
      // from profile UID !!!!
      p = await Profile.getProfilefromUID(uid);
      if (p != null) {
        player = p;
      } else {
        //default player

        //exception is recommended but tests needed
        //TODO TEST FUNCTIONALITY WITH EXCEPTION
        throw UserDoesNotExistException();

      }
    } else {
      // default player

      //exception is recommended but tests needed
      //TODO TEST FUNCTIONALITY WITH EXCEPTION
      throw UserNotLoggedInException();
    }
  }



  /// Starts the quiz.
  ///
  /// This method is called when the user enters the quiz view. It uses the
  /// parameter from the widget to send the category to the model and get
  /// the correct questions from the quiz. It initailizes the parameters
  /// [_quiz], [_category], [_totalQuestions], [_currentQuestionIndex],
  /// [_currentPoints] and [_currentQuestionAnswered].
  void startQuiz({
    int? id,
    required String category,
    required int numberOfQuestions,
    String? creatorUsername,
  }) {
    _category = category;
    _totalQuestions = numberOfQuestions;
    _currentQuestionIndex = 0;
    _currentPoints = 0;
    _currentQuestionAnswered = false;

    _quiz = Quiz.normal(
      id: id ?? 1,
      noOfQuestions: _totalQuestions,
      category: _category,
      creatorUsername: creatorUsername ?? 'public',
    );
  }

  /// Returns the current question text to be displayed in the UI.
  String getCurrentQuestionText() {
    return _quiz.getQuestions()[_currentQuestionIndex].getText();
  }

  /// Returns the current question answer text to be displayed in the UI. It
  /// takes the parameter [index] to determine which answer to return.
  String getAnswerText(int index) {
    return _quiz.getQuestions()[_currentQuestionIndex].getAnswer(index).text;
  }

  /// Returns the current question answer isCorrect value. It takes the
  /// parameter [index] to determine which answer to return.
  bool isAnswerCorrect(int index) {
    return _quiz
        .getQuestions()[_currentQuestionIndex]
        .getAnswer(index)
        .isCorrect;
  }

  /// Returns the current points as a string to be displayed in the UI.
  String pointTracker() {
    return '$_currentPoints points';
  }

  /// Returns the question to be displayed in the UI. It shows the
  /// [currentQuestionIndex] + 1 and the [totalQuestions].
  String questionTracker() {
    return '${_currentQuestionIndex + 1} / $_totalQuestions';
  }

  /// Updates [_currentQuestionIndex] and [_currentQuestionAnswered] to
  /// display the next question in the UI. It also resets the timer.
  /// If there are no more question, it calls the method [endQuiz].
  void nextQuestion() async {
    if (_currentQuestionIndex < _totalQuestions - 1) {
      _currentQuestionIndex++;
      _currentQuestionAnswered = false;
      resetTimer();
      notifyListeners();
    } else {
      counter++;
      //TODO WHEN QUIZZES NAMES ARE IMPLEMENTED ADD NAME TO THE QUIZZREQULT
      //TODO GET THE REAL TIME SPENT
      UserQuizzResult r = UserQuizzResult(
          "Test8", correctAnswers, _totalQuestions, _timeLeft.inSeconds);
      UserStatistics? stat = await player.getUserStatistics();
      if (stat != null) {
        print(counter);
        stat.addUserQuizzResult(r);
       await stat.saveStatistics();
      }
      endQuiz();
    }
  }

  /// It is called when the user clicks on an answer button of the last
  /// question. It stops the timer, updates the score of the player and takes
  /// the user to the [StatisticsView].
  void endQuiz() {
    stopTimer();
    player.updateScore("Savo", _category, _currentPoints);
    navigator.currentState?.pop();
    navigator.currentState?.push(
      MaterialPageRoute(builder: (_) => StatisticsView()),
    );
  }

  /// Edits the current score of the user. Takes [isCorrect] as parameter to
  /// decide how to edit the score. In case the answer is correct, it adds 5
  /// points to the current score + the seconds left to answer it.
  /// In case the answer is incorrect, it subtracts 2 points from the current
  /// score. Current score can never be less than 0.
  /// It also sets [_currentQuestionAnswered] to true to avoid the user from
  /// answering the same question twice.
  void editScore(bool isCorrect) {
    if (_currentQuestionAnswered) {
      return;
    }

    if (isCorrect) {
      _currentPoints += 5 + _timeLeft.inSeconds;
      correctAnswers++;
    } else {
      _currentPoints -= 2;
      if (_currentPoints < 0) {
        _currentPoints = 0;
      }
    }

    notifyListeners();
  }

  /// Starts the timer. It is called when the user enters the quiz view.
  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  /// Resets the timer. It is called when the user clicks on an answer button.
  void resetTimer() {
    stopTimer();
    _timeLeft = const Duration(seconds: 15);
    startTimer();
  }

  /// Stops the timer. It is called when the user clicks on an answer button
  /// of the last question.
  void stopTimer() {
    countdownTimer?.cancel();
  }

  /// Sets the [_timeLeft] to the time left in the timer. It is called every
  /// second by the timer.
  /// If the time left finishes, it calls the method [nextQuestion].
  /// It also notifies the UI to update the time left.
  void setCountDown() {
    final reduceSecondsBy = 1;
    final seconds = _timeLeft.inSeconds - reduceSecondsBy;
    if (seconds < 0) {
      countdownTimer?.cancel();
      nextQuestion();
    } else {
      _timeLeft = Duration(seconds: seconds);
      notifyListeners();
    }
  }
}
