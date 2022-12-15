import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queasy/src/model/profile.dart';
import 'package:queasy/src/model/statistics.dart';
import 'package:queasy/utils/exceptions/user_does_not_exist_exception.dart';

class StatisticsViewController {
  UserStatistics? statistics;

  StatisticsViewController(){
    init();
  }

  void init() async {
    Profile? p;
    var uid = getCurrentUserID();
    if(uid != null) {
      p = await Profile.getProfilefromUID(uid);
      if (p != null) {
        statistics = await p.getUserStatistics();
      }else{
        throw UserDoesNotExistException();
      }
    }else
      throw UserNotLoggedInException();
  }
  int getCorrectAnswers(){
    var quiz = statistics?.userQuizzes.last;
    if (quiz != null)
      return quiz.correct;
    else
      return 0;
  }
  int getSecondsSpent(){
    var quiz = statistics?.userQuizzes.last;
    if (quiz != null)
      return quiz.secondsSpent;
    else
      return 0;
  }
  int getPoints(){
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