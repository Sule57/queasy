import 'package:flutter/material.dart';
import 'package:queasy/src.dart';
import '../../../utils/exceptions.dart';
import '../play_quiz/quiz_provider.dart';

class StatisticsProvider with ChangeNotifier {
  late UserStatistics statistics;
  QuizProvider qp;
  late Profile p;
  late int _numberQuiz;
  late List<int> _resultsCorrect;
  late List<ChartData> _chartData;
  late int _overallPercentage;

  late UserQuizzResult _lastQuiz;
  String _quizzName = "";
  int _allQestions = 0;
  int _correct = 0;
  int _secondsSpent = 0;

  get quizzName => _quizzName;

  get allQuestions => _allQestions;

  get correct => _correct;

  get secondsSpent => _secondsSpent;

  get numberQuiz => _numberQuiz;

  get resultsCorrect => _resultsCorrect;
  get chartData => _chartData;
  get overallPercentage => _overallPercentage;

  StatisticsProvider(this.qp) {
    // setStatisticsProvider();
    initStatisticsProvider();
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

  void initStatisticsProvider() async {
    var uid = getCurrentUserID();
    if (uid != null) {
      // get the user profile who played the quizz
      p = (await Profile.getProfilefromUID(uid))!;
      statistics = (await p.getUserStatistics())!;
    } else
      throw UserNotLoggedInException();
    _numberQuiz = statistics.userQuizzes.length;
    //Chart Data
    _resultsCorrect = new List<int>.filled(_numberQuiz, 0, growable: false);
    int n = 0;
    for (UserQuizzResult r in statistics.userQuizzes) {
      _resultsCorrect[n] = r.correct;
      n++;
    }
    int z = _numberQuiz;
    int m = 0;
    int sum = 0;
    _chartData =
        new List<ChartData>.filled(n, ChartData('Quiz 0', 0), growable: false);
    while (z != 0) {
      sum = sum + _resultsCorrect[m];
      _chartData[m] = ChartData(
          'Q' + (m + 1).toString(), (sum / ((m + 1) * 5) * 100).round());
      z--;
      m++;
    }
    _overallPercentage = (sum / (_numberQuiz * 5) * 100).round();

    notifyListeners();
  }
}

class ChartData {
  ChartData(this.quizNumber, this.userStatistic);
  final String quizNumber;
  final num userStatistic;
}
