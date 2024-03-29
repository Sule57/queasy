import 'package:flutter/material.dart';
import 'package:queasy/src.dart';
import '../../../utils/exceptions.dart';
import '../play_quiz/play_quiz_provider.dart';
/// The class provides data from the model to the [StatisticsView]
/// the field [statistics] is used to get the statistical data from the current playing user
/// the field [qp] is used to get tha last quizz rezult from the end of the quizz
/// the field [p] is the current user Profile playing the quizz
/// the field [_chartData] is used to store the data of each played quizz for the statistics in the profile view
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
  ///initializes  the data to be presented in [StatisticsView]
  ///returns [true] if successful
  bool setStatisticsView() {
    //the exception is not needed anymore
    // but we are in release phase so just in case I will not touch it
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
  ///The method initializes the provider with all the [UserQuizResult] of the current [Profile] for the statistics charts in the [ProfileView]
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
/// A class for representing the data in a chart in the ProfileView
class ChartData {
  ChartData(this.quizNumber, this.userStatistic);
  final String quizNumber;
  final num userStatistic;
}
