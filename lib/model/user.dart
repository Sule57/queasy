import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

String? getCurrentUserID() {
  if (FirebaseAuth.instance.currentUser != null) {
    print(FirebaseAuth.instance.currentUser?.uid);
    return FirebaseAuth.instance.currentUser?.uid;
  }
  return null;
}

class Profile {
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
  Profile({
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
  Profile.fromJson(Map<String, dynamic> json)
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
      FirebaseFirestore.instance
          .collection('users')
          .doc(this.username)
          .set(this.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Increment the score of the user in the firebase by the score achieved in the current quiz
  /// @param username The username of the user
  void updateScore(String username, String category, int score) {
    _firebaseFirestore = FirebaseFirestore.instance;
    _firebaseFirestore.collection('users').doc(username).update({
      'scores.$category': FieldValue.increment(score),
    });
  }

  //START OF METHODS FOR PROFILE VIEW
  /// Updates the user's username in the Firebase Database
  /// @param currentUsername - username of the user who's username to change
  /// @param newUsername - username to change the current username to
  /// @return true - username was updated successfully
  /// @return false - username was not updated successfully
  bool updateUsername(String currentUsername, String newUsername) {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUsername)
          .update({'username': newUsername});
      return true;
    } catch (e) {
      return false;
    }
  }

  bool updateBio(String username, String newBio) {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(username)
          .update({'bio': newBio});
      return true;
    } catch (e) {
      return false;
    }
  }

  bool updateName(String username, String newFirstName, String newLastName) {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(username)
          .update({'firstName': newFirstName, 'lastName': newLastName});
      return true;
    } catch (e) {
      return false;
    }
  }

  bool updateBirthday(String username, String newMonth, int newDay) {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(username)
          .update({'birthdayMonth': newMonth, 'birthdayDay': newDay});
      return true;
    } catch (e) {
      return false;
    }
  }

  bool updateEmail(String currentEmail, String newEmail, String password) {
    try {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          user.reauthenticateWithCredential(EmailAuthProvider.credential(
              email: currentEmail, password: password));
          user.updateEmail(newEmail);
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  bool updatePassword(
      String email, String currentPassword, String newPassword) {
    try {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          user.reauthenticateWithCredential(EmailAuthProvider.credential(
              email: email, password: currentPassword));
          user.updatePassword(newPassword);
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  bool signOut() {
    try {
      FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool deleteAccount(String email, String password) {
    try {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user != null) {
          user.reauthenticateWithCredential(
              EmailAuthProvider.credential(email: email, password: password));
          user.delete();
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  }
  //END OF METHODS FOR PROFILE VIEW
}
