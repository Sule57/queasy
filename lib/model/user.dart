import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String username;
  String email;
  String hashPassword;
  String? firstName;
  String? lastName;
  String? profilePicture;
  String? bio;
  int? age;
  late FirebaseFirestore _firebaseFirestore;

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
