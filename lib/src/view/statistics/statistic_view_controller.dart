import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queasy/src/model/profile.dart';
import 'package:queasy/src/model/statistics.dart';

import '../../../utils/exceptions.dart';


class StatisticsViewController {
  UserStatistics? statistics;

  StatisticsViewController(){
    init();
  }
/// initializes the statistics with data from firebase
  void init() async {
    Profile? p;
    var uid = getCurrentUserID();
    if(uid != null) {
      // get the user profile who palyed the quizz
      p = await Profile.getProfilefromUID(uid);
      if (p != null) {
        // get his statistics so you can display them
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