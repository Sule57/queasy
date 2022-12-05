import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queasy/src/model/profile.dart';

class UserStatistics{
  String username;
  List<UserQuizzResults> userQuizzes = [];
  UserStatistics(this.username, this.userQuizzes);

  factory UserStatistics.fromJson(String usr, Map<String, dynamic> json){

    String username = usr;
    List<UserQuizzResults> q = [];
    print(json.keys);
    print(json['quizz1']['correct']);
    for(String str in json.keys){
      q.add(UserQuizzResults.fromJson(json[str]));
    }
    return UserStatistics(username, q);

  }






Map<String, dynamic> toJson(){
    Map<String, dynamic> m = {};
   for(UserQuizzResults q in userQuizzes){
     m.addAll({q.quizzName: q.toJson()});
   }

  return m;
  }
  Future<void> addQuizzStatistics(FirebaseFirestore firestore) async{
    firestore.collection('UserStatistics').doc(this.username).update(this.toJson());
  }

  @override
  String toString() {
    return 'UserStatistics{username: $username, userQuizzes: $userQuizzes}';
  }
}

class UserQuizzResults {
  String quizzName;
  int allQestions;
  int correct;
  double secondsSpent;

  UserQuizzResults(this.quizzName, this.correct,this.allQestions, this.secondsSpent);

  UserQuizzResults.fromJson(Map<String, dynamic> json):
      quizzName = json.keys.toList()[0],
      allQestions = json['all'],
      correct = json['correct'],
      secondsSpent = json['timeSpent'];
  Map toJson() => {

      'all': allQestions,
      'correct': correct,
      'timeSpent': secondsSpent,

  };

  @override
  String toString() {
    return 'UserQuizzResults{quizzName: $quizzName, allQestions: $allQestions, correct: $correct, secondsSpent: $secondsSpent}';
  }
}