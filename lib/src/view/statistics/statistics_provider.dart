import 'package:flutter/material.dart';
import 'package:queasy/src.dart';
import '../../../utils/exceptions.dart';
import '../play_quiz/play_quiz_provider.dart';

class StatisticsProvider with ChangeNotifier {
  late UserStatistics statistics;
  PlayQuizProvider qp;
  late Profile p;
  int _numberQuiz = 0;
  late List<int> _resultsCorrect;
  late List<ChartData> _chartData;
  int _overallPercentage = 0;

  late UserQuizResult _lastQuiz;
  String _quizName = "";
  int _allQuestions = 0;
  int _correct = 0;
  int _secondsSpent = 0;

  get quizName => _quizName;

  get allQuestions => _allQuestions;

  get correct => _correct;

  get secondsSpent => _secondsSpent;

  get numberQuiz => _numberQuiz;

  get resultsCorrect => _resultsCorrect;
  get chartData => _chartData;
  get overallPercentage => _overallPercentage;

  StatisticsProvider(this.qp) {
    initStatisticsProvider();
  }

  bool setStatisticsView() {
    try {
      _lastQuiz = qp.quizResult;
      _quizName = _lastQuiz.quizzName;
      _allQuestions = _lastQuiz.allQestions;
      _correct = _lastQuiz.correct;
      _secondsSpent = _lastQuiz.secondsSpent;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> initStatisticsProvider() async {
    var uid = await getCurrentUserID();
    if (uid != null) {
      // get the user profile who played the quizz
      p = (await Profile.getProfileFromUID(uid))!;
      statistics = (await p.getUserStatistics())!;
    } else {
      throw UserNotLoggedInException();
    }
    if (statistics.userQuizzes.isNotEmpty) {
      _numberQuiz = statistics.userQuizzes.length;
      //Chart Data
      _resultsCorrect = new List<int>.filled(_numberQuiz, 0, growable: false);
      int n = 0;
      for (UserQuizResult r in statistics.userQuizzes) {
        _resultsCorrect[n] = r.correct;
        n++;
      }
      int z = _numberQuiz;
      int m = 0;
      int sum = 0;
      _chartData = new List<ChartData>.filled(n, ChartData('Quiz 0', 0),
          growable: false);
      while (z != 0) {
        sum = sum + _resultsCorrect[m];
        _chartData[m] = ChartData(
            'Q' + (m + 1).toString(), (sum / ((m + 1) * 5) * 100).round());
        z--;
        m++;
      }
      _overallPercentage = (sum / (_numberQuiz * 5) * 100).round();
    }
  }
}

class ChartData {
  ChartData(this.quizNumber, this.userStatistic);
  final String quizNumber;
  final num userStatistic;
}
