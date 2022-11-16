import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  late FirebaseFirestore _firebaseFirestore;

  String username;
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
    required this.hashPassword,
    this.firstName ='',
    this.lastName ='',
    this.profilePicture ='',
    this.bio ='',
    this.age =0,

  }){
    _firebaseFirestore = FirebaseFirestore.instance;
  }//use this for later!!! :    _firebaseFirestore = FirebaseFirestore.instance;
///This constructor is used only for unit tests
  User.test({
    required this.username,
    required this.hashPassword,
    this.firstName ='',
    this.lastName ='',
    this.profilePicture ='',
    this.bio ='',
    this.age =0,
    required FirebaseFirestore firestore,
  });



  ///Creates a user instance from json
  ///Note: the json format must be the following:
  ///USERNAME: {
  ///   FIELDS: FIELDS
  ///   }
  ///@param json should be json data
  User.fromJson(Map<String, dynamic> json)
      : username = json.keys.toList()[0],// this is how to get the username
        hashPassword = json[json.keys.toList()[0]]['hashPassword'],
        firstName = json[json.keys.toList()[0]]['firstName'],
        lastName = json[json.keys.toList()[0]]['lastName'],
        profilePicture = json[json.keys.toList()[0]]['profilePicture'],
        bio = json[json.keys.toList()[0]]['bio'],
        age = json[json.keys.toList()[0]]['age'];


  @override
  String toString() {
    return 'User{ username: $username, hashPassword: $hashPassword, firstName: $firstName, lastName: $lastName, bio: $bio, age: $age, }';
  }

  /// converts user object to json object
  Map<String, dynamic> toJson() => {
    'lastName': lastName,
    'firstName': firstName,
    'hashPassword': hashPassword,
    'bio': bio,
    'age': age,
    'scores': publicScore,
    'privateScore': privatecScore,

  };


  ///registers user the following way: creates document with the username and collection with its attributes
  ///@param firestore database instance
  bool registerUser(FirebaseFirestore firestore) {
    try {
      firestore.collection('users').doc(this.username).set(this.toJson());
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



