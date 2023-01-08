import 'package:flutter/material.dart';
import 'package:queasy/src.dart';
import '../../../utils/exceptions.dart';
import '../play_quiz/quiz_provider.dart';


class StatisticsProvider with ChangeNotifier {

  late UserStatistics statistics;

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
    _lastQuiz = QuizProvider.quizzResult;



    _quizzName = _lastQuiz.quizzName;
    _allQestions = _lastQuiz.allQestions;
    _correct = _lastQuiz.correct;
    _secondsSpent = _lastQuiz.secondsSpent;

    notifyListeners();

  }
}
