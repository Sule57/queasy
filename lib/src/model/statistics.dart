import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queasy/src/model/profile.dart';

class UserStatistics{
  String username;
  List<UserQuizzResult> userQuizzes = [];

  late var firestore = FirebaseFirestore.instance;
  UserStatistics(this.username, this.userQuizzes);
  UserStatistics.test(this.username, this.userQuizzes, this.firestore);
  factory UserStatistics.fromJson(String usr, Map<String, dynamic> json){

    String username = usr;
    List<UserQuizzResult> q = [];
    print(json.keys);
    print(json['quizz1']['correct']);
    for(String str in json.keys){
      q.add(UserQuizzResult.fromJson(json[str]));
    }
    return UserStatistics(username, q);

  }

Map<String, dynamic> toJson(){
    Map<String, dynamic> m = {};
   for(UserQuizzResult q in userQuizzes){
     m.addAll({q.quizzName: q.toJson()});
   }

  return m;
  }
  /// stores the statistics to the database
  Future<void> saveStatistics() async{
    firestore.collection('UserStatistics').doc(this.username).update(this.toJson());
  }
  //very important note:
  // TO STORE THE DATA INTO FIREBASE YOU MUST RUN saveStatistics()
  /// adds UserQuizzResult to the statistics list
 void addUserQuizzResult(UserQuizzResult r){
    //this does not saves data to the database
   // you must run saveStatistics()
    this.userQuizzes.add(r);

 }
  @override
  String toString() {
    return 'UserStatistics{username: $username, userQuizzes: $userQuizzes}';
  }
}

class UserQuizzResult {
  String quizzName;
  int allQestions;
  int correct;
  double secondsSpent;

  UserQuizzResult(this.quizzName, this.correct,this.allQestions, this.secondsSpent);

  UserQuizzResult.fromJson(Map<String, dynamic> json):
      quizzName = json.keys.toList()[0],
      allQestions = json['all'],
      correct = json['correct'],
      secondsSpent = json['timeSpent'];
  Map<String, dynamic> toJson() => {

      'all': allQestions,
      'correct': correct,
      'timeSpent': secondsSpent,

  };



  @override
  String toString() {
    return 'UserQuizzResults{quizzName: $quizzName, allQestions: $allQestions, correct: $correct, secondsSpent: $secondsSpent}';
  }
}