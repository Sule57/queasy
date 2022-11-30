import 'dart:async';

import 'package:flutter/material.dart';
import 'package:queasy/main.dart';
import 'package:queasy/src/view/statistics_view.dart';

import '../../model/profile.dart';
import '../../model/quiz.dart';

class QuizProvider with ChangeNotifier {
  final Quiz _quiz = Quiz.normal(
    id: 1,
    noOfQuestions: 5,
    //TODO dummy data, change to actual data
    category: 'Science',
    creatorUsername: 'public',
  );

  Profile player = Profile(
    username: 'Savo',
    email: 'savo@email.com',
    hashPassword: '1234',
  );

  final String _category = 'Science';
  late final int _totalQuestions = 5;
  int _currentQuestionIndex = 0;
  int _currentPoints = 0;
  bool _currentQuestionAnswered = false;
  static Timer? countdownTimer;
  static Duration timeLeft = const Duration(seconds: 10);

  get category => _category;
  get quiz => _quiz;

  String getCurrentQuestionText() {
    return _quiz.getQuestions()[_currentQuestionIndex].getText();
  }

  String getAnswerText(int index) {
    return _quiz
        .getQuestions()[_currentQuestionIndex]
        .getAnswer(index)
        .text;
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
      _currentPoints += 5 + timeLeft.inSeconds;
    } else {
      _currentPoints -= 3;
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
    timeLeft = const Duration(seconds: 10);
    startTimer();
  }

  void stopTimer() {
    countdownTimer?.cancel();
  }

  void setCountDown() {
    final reduceSecondsBy = 1;
    final seconds = timeLeft.inSeconds - reduceSecondsBy;
    if (seconds < 0) {
      countdownTimer?.cancel();
      nextQuestion();
    } else {
      timeLeft = Duration(seconds: seconds);
      notifyListeners();
    }
  }

  String getTimeLeft() {
    return timeLeft.inSeconds.toString();
  }
}
