import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queasy/src/model/profile.dart';
/// a class for statistics for each user
/// [username] this is the username of the user
/// [userQuizzes] list with user results from past quizzes
class UserStatistics{
  String username;
  List<UserQuizzResult> userQuizzes = [];

  late var firestore = FirebaseFirestore.instance;
  UserStatistics(this.username, this.userQuizzes);
  UserStatistics.test(this.username, this.userQuizzes, this.firestore);
/// a JSON constructor that converts json object to a UserStatistics instance
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
/// converts UserStatistics instance to json object of type
  /// Map<String, dynamic>
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
/// stores a user quizz result
/// [quizzName] the name of the quizz
/// [allQestions] the number of questions in the quizz
/// [correct] the correct answers the user has given
/// [secondsSpent] time spent on the quizz in seconds
class UserQuizzResult {
  String quizzName;
  int allQestions;
  int correct;
  double secondsSpent;

  UserQuizzResult(this.quizzName, this.correct,this.allQestions, this.secondsSpent);

/// converts a json object to UserQUizzResult instance
  /// [json] json object of type Map<String, dynamic>
  UserQuizzResult.fromJson(Map<String, dynamic> json):
      quizzName = json.keys.toList()[0],
      allQestions = json['all'],
      correct = json['correct'],
      secondsSpent = json['timeSpent'];

  ///converts UserResultQuizz instance to json object of type
  ///Map<String, dynamic>
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