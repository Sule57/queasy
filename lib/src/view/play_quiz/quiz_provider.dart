import 'dart:async';

import 'package:flutter/material.dart';
import 'package:queasy/main.dart';


import '../../model/profile.dart';
import '../../model/quiz.dart';
import '../statistics/statistics_view.dart';

class QuizProvider with ChangeNotifier {
  // QuizProvider._internal();

  // static final QuizProvider _instance = QuizProvider._internal();
  //
  // factory QuizProvider() {
  //   return _instance;
  // }

  late Quiz _quiz;

  Profile player = Profile(
    username: 'Savo',
    email: 'savo@email.com',
    hashPassword: '1234',
  );

  late String _category;
  late int _totalQuestions;
  int _currentQuestionIndex = 0;
  int _currentPoints = 0;
  bool _currentQuestionAnswered = false;
  static Timer? countdownTimer;
  static Duration _timeLeft = const Duration(seconds: 15);

  get category => _category;
  get quiz => _quiz;
  get timeLeft => _timeLeft.inSeconds.toString();

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

    _quiz = Quiz.normal(
      id: id ?? 1,
      noOfQuestions: _totalQuestions,
      category: _category,
      creatorUsername: creatorUsername ?? 'public',
    );
  }

  String getCurrentQuestionText() {
    return _quiz.getQuestions()[_currentQuestionIndex].getText();
  }

  String getAnswerText(int index) {
    return _quiz.getQuestions()[_currentQuestionIndex].getAnswer(index).text;
  }

  bool isAnswerCorrect(int index) {
    return _quiz
        .getQuestions()[_currentQuestionIndex]
        .getAnswer(index)
        .isCorrect;
  }

  String pointTracker() {
    return '$_currentPoints points';
  }

  String questionTracker() {
    return '${_currentQuestionIndex + 1} / $_totalQuestions';
  }

  /// Updates the question index, showing the next question in the list. If
  /// there is no more questions, it updates the score of the player with
  /// the current points. Returns `true` if there is a next question, `false`
  /// if the current question is the last one.
  void nextQuestion() {
    if (_currentQuestionIndex < _totalQuestions - 1) {
      _currentQuestionIndex++;
      _currentQuestionAnswered = false;
      resetTimer();
      notifyListeners();
    } else {
      stopTimer();
      player.updateScore("Savo", _category, _currentPoints);
      navigator.currentState?.push(
        MaterialPageRoute(builder: (_) => StatisticsView()),
      );
    }
  }

  /// Edits the current score of the user. Takes [isCorrect] as parameter to
  /// decide how to edit the score. In case the answer is correct, it adds 5
  /// points to the current score. In case the answer is incorrect, it subtracts
  /// 1 points from the current score. Current score can never be less than 0.
  void editScore(bool isCorrect) {
    if (_currentQuestionAnswered) {
      return;
    }

    if (isCorrect) {
      _currentPoints += 5 + _timeLeft.inSeconds;
    } else {
      _currentPoints -= 2;
      if (_currentPoints < 0) {
        _currentPoints = 0;
      }
    }

    notifyListeners();
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void resetTimer() {
    stopTimer();
    _timeLeft = const Duration(seconds: 15);
    startTimer();
  }

  void stopTimer() {
    countdownTimer?.cancel();
  }

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
