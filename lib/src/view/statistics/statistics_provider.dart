import 'package:flutter/material.dart';
import 'package:queasy/src.dart';
import '../../../utils/exceptions.dart';


class StatisticsProvider with ChangeNotifier {

  late UserStatistics statistics;
  late Profile p;

  late UserQuizzResult _lastQuiz;
  late String _quizzName;
  late int _allQestions;
  late int _correct;
  late int _secondsSpent;

  get quizzName => _quizzName;
  get allQuestions => _allQestions;
  get correct => _correct;
  get secondsSpent => _secondsSpent;


  StatisticsProvider(){
    initStatisticsProvider();
  }

  void initStatisticsProvider() async{
    var uid = getCurrentUserID();
    if(uid != null) {
      // get the user profile who played the quizz
      p = (await Profile.getProfilefromUID(uid))!;
      statistics = (await p.getUserStatistics())!;
    }else
      throw UserNotLoggedInException();

    _lastQuiz = statistics.userQuizzes.last;
    _quizzName = _lastQuiz.quizzName;
    _allQestions = _lastQuiz.allQestions;
    _correct = _lastQuiz.correct;
    _secondsSpent = _lastQuiz.secondsSpent;

    notifyListeners();

  }
}
