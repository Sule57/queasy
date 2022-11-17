import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  late FirebaseFirestore _firebaseFirestore;
  String username;
  String email;
  String hashPassword;
  String? firstName;
  String? lastName;
  String? profilePicture;
  String? bio;
  int? age;
  //In the database publicScore and private score are stored as collections
  Map<String, dynamic> publicScore = {};
  Map<String, dynamic> privatecScore = {};
  User({
    required this.username,
    required this.email,
    required this.hashPassword,
    this.firstName,
    this.lastName,
    this.profilePicture,
    this.bio,
    this.age,
  });


  //TODO methods for user data

  //TODO NOT YET DONE METHOD
  User.fromJson(Map<String, dynamic> json)
      : username = json['name'],
        email = json['email'],
        hashPassword = json['hashPassword'];
  // firstName = json['firstName'];
  // lastName = json['lastName'];
  // profilePicture = json['profilePicture'];
  // bio = json['bio'];
  // age = age['age'];
  // privateScore = json['privateScore'];

  /// converts user object to json object
  Map<String, dynamic> toJson() => {
    'lastName': lastName,
    'name': firstName,
    'hashPassword': hashPassword,
    'bio': bio,
    'age': age,
    'scores': publicScore,
    'privateScore': privatecScore,

  };
  ///registers user
  bool registerUser() {
    try {
      FirebaseFirestore.instance.collection('users').doc(this.username).set(this.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }
  /// Increment the score of the user in the firebase by the score achieved in the current quiz
  /// @param username The username of the user
  void updateScore(String username, String category, int score) {
    _firebaseFirestore = FirebaseFirestore.instance;
    _firebaseFirestore.collection('users')
        .doc(username)
        .update({
      'scores.$category': FieldValue.increment(score),
    });
  }
}



