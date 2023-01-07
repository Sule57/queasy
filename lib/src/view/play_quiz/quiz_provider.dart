/// ****************************************************************************
/// Created by Julia Agüero
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

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
/// The late parameter [_quizCategory] is the category of the quiz. It is
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
  late Quiz _quiz;
  late Profile player;
  late String? _quizCategory;
  late String? _quizId;
  late int _totalQuestions = 5;
  int _currentQuestionIndex = 0;
  int _currentPoints = 0;
  int correctAnswers = 0;
  bool _currentQuestionAnswered = false;
  Timer? countdownTimer;
  Duration _timeLeft = const Duration(seconds: 15);
  int _secondsPassed = 0;
  get quizCategory => _quizCategory;
  get quiz => _quiz;
  get timeLeft => _timeLeft.inSeconds.toString();

// assign the current user to the app
  QuizProvider() {
    // default profile
    player = Profile(
      username: 'Savo',
      email: 'savo@email.com',
    );
    init();
  }

  //player = Profile.getProfilefromUID(getCurrentUserID());
  /// initializes [player] as the current logged in user
  void init() async {
    String? userId = getCurrentUserID();
    Profile? profile;
    if (userId != null) {
      // very important class method creating Profile instance
      // from profile UID !!!!
      profile = await Profile.getProfilefromUID(userId);
      if (profile != null) {
        player = profile;
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
  /// [_quiz], [_quizCategory], [_totalQuestions], [_currentQuestionIndex],
  /// [_currentPoints] and [_currentQuestionAnswered].
  Future<bool> startQuiz({
    String? id,
    String? category,
    int? numberOfQuestions,
    String? creatorUsername,
  }) async {
    _quizId = id;
    _quizCategory = category;
    _currentQuestionIndex = 0;
    _currentPoints = 0;
    _currentQuestionAnswered = false;
    bool isLoading = true;

    if (_quizCategory != null && _quizId == null) {
      _quiz = await Quiz.createRandom(
        category: Category(
          name: _quizCategory!,
        ),
        noOfQuestions: _totalQuestions,
        isPublic: true,
      ).getRandomQuestions();
      isLoading = false;
    } else if (_quizId != null && _quizCategory == null) {
      _quiz = await Quiz().retrieveQuizFromId(
        id: _quizId!,
      );
      _quizCategory = _quiz.category.name;
      _totalQuestions = _quiz.noOfQuestions;
      isLoading = false;
    } else {
      throw Exception('_category == null || _id == null');
    }
    return isLoading;
  }

  /// Returns the current question text to be displayed in the UI.
  String getCurrentQuestionText() {
    return _quiz.questions[_currentQuestionIndex].getText();
  }

  /// Returns the current question answer text to be displayed in the UI. It
  /// takes the parameter [index] to determine which answer to return.
  String getAnswerText(int index) {
    return _quiz.questions[_currentQuestionIndex].getAnswer(index).text;
  }

  /// Returns the current question answer isCorrect value. It takes the
  /// parameter [index] to determine which answer to return.
  bool isAnswerCorrect(int index) {
    return _quiz.questions[_currentQuestionIndex].getAnswer(index).isCorrect;
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
      await endQuiz();
    }
  }

  /// It is called when the user clicks on an answer button of the last
  /// question. It stops the timer, updates the score of the player and takes
  /// the user to the [StatisticsView].
  Future<void> endQuiz() async {
    stopTimer();

    //TODO WHEN QUIZZES NAMES ARE IMPLEMENTED ADD NAME TO THE QUIZZREQULT
    //TODO GET THE REAL TIME SPENT
    if (_quizCategory != null) {
      UserStatistics? stat = await player.getUserStatistics();
      if (stat != null) {
        String name = _quizCategory! + (stat.userQuizzes.length + 1).toString();

        UserQuizzResult r = UserQuizzResult(
            name, correctAnswers, _totalQuestions, _secondsPassed);

        stat.addUserQuizzResult(r);
        await stat.saveStatistics();
      }
    }
    if (_quizCategory != null) {
      //TODO check this
      player.updateScore(_quizCategory!, _currentPoints);
      print('seconds passed at the end of the quizz: $_secondsPassed');
    }
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
    _timeLeft = const Duration(seconds: 15);
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
      _secondsPassed++;
      print('$_secondsPassed seconds passed');
      notifyListeners();
    }
  }
}
