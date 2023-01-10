import 'package:flutter/material.dart';
import 'package:queasy/src.dart';
import '../play_quiz/quiz_provider.dart';

class StatisticsProvider with ChangeNotifier {
  late UserStatistics statistics;
  QuizProvider qp;

  late UserQuizzResult _lastQuiz;
  String _quizzName = "";
  int _allQestions = 0;
  int _correct = 0;
  int _secondsSpent = 0;

  get quizzName => _quizzName;
  get allQuestions => _allQestions;
  get correct => _correct;
  get secondsSpent => _secondsSpent;

  StatisticsProvider(this.qp) {
    // setStatisticsProvider();
  }

  bool setStatisticsProvider() {
    try {
      _lastQuiz = qp.quizzResult;

      _quizzName = _lastQuiz.quizzName;
      _allQestions = _lastQuiz.allQestions;
      _correct = _lastQuiz.correct;
      _secondsSpent = _lastQuiz.secondsSpent;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
