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
  /// @param [currentUsername] - username of the user whose username to change
  /// @param [newUsername] - username to change the current username to
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

  ///updates the bio information of the user in the Firebase Database
  ///@param [username] - the current username of the user
  ///@param [newBio] - the new bio information
  ///@return true - bio was updated successfully
  ///@return false - bio was not updated successfully
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

  ///updates the first and lastname of the user in the Firebase Database
  ///@param [username] - the current username of the user
  ///@param [newFirstName] - the new firstname
  ///@param [newLastName] - the new lastname
  ///@return true - name was updated successfully
  ///@return false - name was not updated successfully
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

  ///updates the birthday of the user in the Firebase Database
  ///@param [username] - the current username of the user
  ///@param [newMonth] - the new month of birth
  ///@param [newDay] - the new day of birth
  ///@return true - birthday was updated successfully
  ///@return false - birthday couldn't be updated
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

  ///updates the email of the user in the Firebase Database
  ///@param [currentEmail] - the current email of the user
  ///@param [newEmail] - the new email
  ///@param [password] - the password of the user for authentication
  ///@return true - email was updated successfully
  ///@return false - email couldn't be updated
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

  ///updates the password of the user in the Firebase Database
  ///@param [email] - the current username of the user for authentication
  ///@param [currentPassword] - the current password of the user
  ///@param [newPassword] - the new password
  ///@return true - password was updated successfully
  ///@return false - password couldn't be updated
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

  ///signs out the user from the system
  ///@return true - the user is signed out successfully
  ///@return false - the user couldn't be signed out
  bool signOut() {
    try {
      FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  ///deletes the account of the user from the Firebase Database
  ///@param [email] - the current username of the user needed for confirmation
  ///@param [password] - the current password of the user needed for confirmation
  ///@return true - account is deleted successfully
  ///@return false - account couldn't be deleted
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
