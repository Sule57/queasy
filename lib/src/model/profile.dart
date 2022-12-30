import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:queasy/src/model/statistics.dart';
import '../../utils/exceptions.dart';

String? getCurrentUserID() {
  if (FirebaseAuth.instance.currentUser != null) {
    return FirebaseAuth.instance.currentUser?.uid;
  }
  return null;
}

///Profile class is an extention of the firebase user
///adapted for the needs of the quizz application
/// [email] email field
/// [username] username
/// [hashPassword] password
/// [firstName] user first name
/// [lastName] user last name
/// [profilePicture] path to the profile picture
/// [bio] user description
/// [age] user age
class Profile {
  static int globalCounter = 0;
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
  // it must be late so
  late var firestore = FirebaseFirestore.instance;
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
  });

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
    required this.firestore,
  });

  ///This constructor is used only for unit tests

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
        age = json['age'],
        privatecScore = json['privateScore'],
        publicScore = json['scores'];

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

  /// registers user the following way: creates document with the usaername and collection with its attributes
  /// returns true if successful
  /// throws an [UserAlreadyExistsException] if the user with the same username already exists in the database
  Future<bool> registerUser() async {
    await this
        .firestore
        .collection('users')
        .doc(getCurrentUserID())
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        throw UserAlreadyExistsException();
      }
    });

    if (getCurrentUserID() != null) {
      firestore.collection('users').doc(getCurrentUserID()).set(this.toJson());
      UserStatistics s = UserStatistics(this.username, []);
      //Adding the user to the statistics
      Map<String, dynamic> data = {};
      firestore.collection('UserStatistics').doc(this.username).set(data);
      return true;
    }
    return false;
  }

  /// gets the current profile from user uid
  /// [uid] is the firebase user uid
  /// returns a Profile instance
  static Future<Profile?> getProfilefromUID(String uid) async {
    Profile? result;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> j = documentSnapshot.data() as Map<String, dynamic>;
      result = new Profile.fromJson(j);
    });
    return result;
  }

  /// gets a UserStatistics object from the current user
  /// the objects contains all user results from played quizzes
  /// returns null if there is no data
  Future<UserStatistics?> getUserStatistics() async {
    UserStatistics? s = null;
    await firestore
        .collection('UserStatistics')
        .doc(this.username)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        s = UserStatistics.fromJson(
            this.username, documentSnapshot.data() as Map<String, dynamic>);
      } else {
        print("This should never happen");
        s = UserStatistics.fromJson(this.username, {});
      }
    });
    return s;
  }

  /// Increment the score of the user in the firebase by the score achieved in the current quiz
  /// [username] The username of the user
  void updateScore(String username, String category, int score) {
    final firebaseFirestore = FirebaseFirestore.instance;
    firebaseFirestore.collection('users').doc(getCurrentUserID()).update({
      'scores.$category': FieldValue.increment(score),
    });
  }

  //START OF METHODS FOR PROFILE VIEW
  /// Updates the user's username in the Firebase Database
  /// @param [currentUsername] - username of the user whose username to change
  /// @param [newUsername] - username to change the current username to
  /// @return true - username was updated successfully
  /// @return false - username was not updated successfully
  bool updateUsername(String newUsername) {
    try {
      firestore
          .collection('users')
          .doc(getCurrentUserID())
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
  bool updateBio(String newBio) {
    try {
      firestore
          .collection('users')
          .doc(getCurrentUserID())
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
  bool updateName(String newFirstName, String newLastName) {
    try {
      firestore
          .collection('users')
          .doc(getCurrentUserID())
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
  bool updateBirthday(String newMonth, int newDay) {
    try {
      firestore
          .collection('users')
          .doc(getCurrentUserID())
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
  bool updatePicture(String newPic) {
    try {
      firestore
          .collection('users')
          .doc(getCurrentUserID())
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

  Future<void> pickProfileImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("profilePictures/${getCurrentUserID()}");
    // File file = File(image!.path);
    // print(file.path);
    // final metadata = SettableMetadata(
    //     contentType: 'imange/png',
    //     customMetadata: {'picked-file-path': file.path});
    // final uploadTask = ref.putData(await file.readAsBytes(), metadata);
    // ref.getDownloadURL().then((value) {
    //   print(value);
    //   firestore
    //       .collection('users')
    //       .doc(getCurrentUserID())
    //       .update({'profilePicture': value});
    // });
    // try {
    //   await ref.putFile(file);
    // } catch (e) {
    //   print(e);
    // }
    final fileBytes = await image!.readAsBytes();
// var now = DateTime.now().millisecondsSinceEpoch;
// StorageReference reference =
//   FirebaseStorage.instance.ref().child("images/$now");

    try {
      await ref.putData(fileBytes);
      ref.getDownloadURL().then((value) {
        print(value);
        firestore
            .collection('users')
            .doc(getCurrentUserID())
            .update({'profilePicture': value});
      });
    } catch (e) {
      print(e);
    }

    // uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
    //   switch (taskSnapshot.state) {
    //     case TaskState.running:
    //       final progress =
    //           100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
    //       print("Upload is $progress% complete.");
    //       break;
    //     case TaskState.paused:
    //       print("Upload is paused.");
    //       break;
    //     case TaskState.canceled:
    //       print("Upload was canceled");
    //       break;
    //     case TaskState.error:
    //       // Handle unsuccessful uploads
    //       print("Upload FAILED");
    //       break;
    //     case TaskState.success:
    //       // Handle successful uploads on complete
    //       // ...
    //       break;
    //   }
    // });
  }

  // File getProfilePicture(){
  //   Reference ref = FirebaseStorage.instance
  //       .ref()
  //       .child("profilePictures/${getCurrentUserID()}")
  // }
  //END OF METHODS FOR PROFILE VIEW

}
