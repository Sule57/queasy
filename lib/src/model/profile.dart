import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/exceptions/user_already_exists.dart';

String? getCurrentUserID() {
  if (FirebaseAuth.instance.currentUser != null) {
    print(FirebaseAuth.instance.currentUser?.uid);
    return FirebaseAuth.instance.currentUser?.uid;
  }
  return null;
}

class Profile {
  late FirebaseFirestore _firebaseFirestore;
  String email;
  String username;
  String hashPassword;
  String? firstName;
  String? lastName;
  String? profilePicture;
  String? bio;
  int? age;
  String? birthdayMonth;
  int? birthdayDay;
  //In the database publicScore and private score are stored as collections
  Map<String, dynamic> publicScore = {};
  Map<String, dynamic> privatecScore = {};
  Profile({
    required this.username,
    required this.email,
    required this.hashPassword,
    this.firstName = '',
    this.lastName = '',
    this.profilePicture = '',
    this.bio = '',
    this.age = 0,
    this.birthdayMonth = '',
    this.birthdayDay = 0,
  }) {
    _firebaseFirestore = FirebaseFirestore.instance;
  } //use this for later!!! :    _firebaseFirestore = FirebaseFirestore.instance;

  ///This constructor is used only for unit tests
  Profile.test({
    required this.username,
    required this.email,
    required this.hashPassword,
    this.firstName = '',
    this.lastName = '',
    this.profilePicture = '',
    this.bio = '',
    this.age = 0,
    this.birthdayMonth = '',
    this.birthdayDay = 0,
    required FirebaseFirestore firestore,
  });

  /// Creates a user instance from json
  /// Note: the json format must be the following:
  /// USERNAME: {
  ///   FIELDS: FIELDS
  ///   }
  /// [json] should be json data
  Profile.fromJson(Map<String, dynamic> json)
      // : username = json.keys.toList()[0], // this is how to get the username
      // hashPassword = json[json.keys.toList()[0]]['hashPassword'],
      // firstName = json[json.keys.toList()[0]]['firstName'],
      // lastName = json[json.keys.toList()[0]]['lastName'],
      // profilePicture = json[json.keys.toList()[0]]['profilePicture'],
      // bio = json[json.keys.toList()[0]]['bio'],
      // age = json[json.keys.toList()[0]]['age'];
      : username = json['username'],
        hashPassword = json['hashPassword'],
        email = json['email'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        profilePicture = json['profilePicture'],
        bio = json['bio'],
        age = json['age'];

  @override
  String toString() {
    return 'User{ username: $username, hashPassword: $hashPassword, firstName: $firstName, lastName: $lastName, bio: $bio, age: $age, }';
  }

  /// converts user object to json object
  Map<String, dynamic> toJson() => {
        'username': username,
        'lastName': lastName,
        'firstName': firstName,
        'email': email,
        'hashPassword': hashPassword,
        'bio': bio,
        'age': age,
        'scores': publicScore,
        'privateScore': privatecScore,
      };

  /// registers user the following way: creates document with the username and collection with its attributes
  /// returns true if successful
  /// throws UserAlreadyExistsException if the user with the same username already exists in the database
  /// [firestore] database instance
  bool registerUser(FirebaseFirestore firestore){
    try {
      // doesnt work for now 
      // firestore
      //     .collection('users')
      //     .doc(this.username)
      //     .get()
      //     .then((DocumentSnapshot documentSnapshot) {
      //   if (documentSnapshot.exists) {
      //     throw UserAlreadyExistsException();
      //   }
      // });
      firestore.collection('users').doc(this.username).set(this.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }




  /// Increment the score of the user in the firebase by the score achieved in the current quiz
  /// [username] The username of the user
  void updateScore(String username, String category, int score) {
    _firebaseFirestore = FirebaseFirestore.instance;
    _firebaseFirestore.collection('users').doc(this.username).update({
      'scores.$category': FieldValue.increment(score),
    });
  }

  //START OF METHODS FOR PROFILE VIEW
  /// Updates the user's username in the Firebase Database
  /// @param [currentUsername] - username of the user whose username to change
  /// @param [newUsername] - username to change the current username to
  /// @return true - username was updated successfully
  /// @return false - username was not updated successfully
  bool updateUsername(
      String currentUsername, String newUsername, FirebaseFirestore firestore) {
    try {
      firestore
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
  bool updateBio(String username, String newBio, FirebaseFirestore firestore) {
    try {
      firestore.collection('users').doc(username).update({'bio': newBio});
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
  bool updateName(String username, String newFirstName, String newLastName,
      FirebaseFirestore firestore) {
    try {
      firestore
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
  bool updateBirthday(String username, String newMonth, int newDay,
      FirebaseFirestore firestore) {
    try {
      firestore
          .collection('users')
          .doc(username)
          .update({'birthdayMonth': newMonth, 'birthdayDay': newDay});
      return true;
    } catch (e) {
      return false;
    }
  }

  ///updates the Profile Picture of the user in the Firebase Database
  ///@param [username] - the current username of the user
  ///@param [newPic] - the new picture
  ///@return true - picture was updated successfully
  ///@return false - picture couldn't be updated
  bool updatePicture(
      String username, String newPic, FirebaseFirestore firestore) {
    try {
      firestore
          .collection('users')
          .doc(username)
          .update({'profilePicture': newPic});
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
