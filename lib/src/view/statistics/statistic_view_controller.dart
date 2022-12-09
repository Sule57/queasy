import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queasy/src/model/profile.dart';
import 'package:queasy/src/model/statistics.dart';

class StatisticsViewController {
  UserStatistics? statistics;

  StatisticsViewController(){
    init();
  }

  void init() async {
    Profile? p;
    var uid = getCurrentUserID();
    if(uid != null)
      p =  await Profile.getProfilefromUID(uid);
      if(p != null)
        statistics = await p.getUserStatistics();
  }
  int getCorrectAnswers(){
    var quiz = statistics?.userQuizzes.last;
    if (quiz != null)
      return quiz.correct;
    else
      return 0;
  }
  double getSecondsSpent(){
    var quiz = statistics?.userQuizzes.last;
    if (quiz != null)
      return quiz.secondsSpent;
    else
      return 0;
  }
  double getPoints(){
    var quiz = statistics?.userQuizzes.last;
    if (quiz != null)
      return quiz.secondsSpent + quiz.correct;
    else
      return 0;
  }
  int getCorrectPercentage(){
    var quiz = statistics?.userQuizzes.last;
    if (quiz != null)
      return quiz.correct*20;
    else
      return 0;
  }
}