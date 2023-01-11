import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:queasy/src.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/exceptions.dart';

///Returns the current user's uid that is stored in Firebase Authentication.
///It returns null if the uid cannot be found. This can happen when the user is not signed in.
String? getCurrentUserID() {
  if (FirebaseAuth.instance.currentUser != null) {
    return FirebaseAuth.instance.currentUser?.uid;
  }
  return null;
}

///Reutrns the current user's username that is stored in their document in the Firebase Database.
///Returns 'something' if the username cannot be found.
Future<String?> getCurrentUserUsername() async {
  String? id;
  if (await FirebaseAuth.instance.currentUser != null) {
    id = await FirebaseAuth.instance.currentUser?.uid;
  }
  String username = 'something';
  await FirebaseFirestore.instance
      .collection('users')
      .doc(id)
      .get()
      .then((value) {
    username = value.data()!['username'];
  });
  return username;
}

///Profile class is an extention of the firebase user
///adapted for the needs of the quizz application
///It has direct access to the
///firebase and is used to store a user or update it in the database.
/// [email] email field
/// [username] username
/// [firstName] user first name
/// [lastName] user last name
/// [profilePicture] path to the profile picture
/// [bio] user description
/// [age] user age
class Profile {
  //TODO: Comment for global counter
  static int globalCounter = 0;

  ///The parameter [email] represents the email of this profile.
  String email;

  ///The parameter username represents the username of this profile.
  String username;

  ///The parameter firstName represents the firstName of this profile.
  String? firstName;

  ///The parameter lastName represents the lastName of this profile.
  String? lastName;

  ///The parameter profilePicture represents the profilePicture of this profile.
  String? profilePicture;

  ///The parameter bio represents the bio of this profile.
  String? bio;

  ///The parameter age represents the age of this profile.
  int? age;

  ///The parameter birthdayMonth represents the birthdayMonth of this profile.
  String? birthdayMonth;

  ///The parameter birthdayDay represents the birthdayDay of this profile.
  int? birthdayDay;

  ///The parameter uid represents the uid of this profile.
  String? uid;

  ///The parameter test represents whether this profile is constructed for tests or for app use.
  late bool test = false;

  // it must be late so
  ///The parameter firestore represents the firestore of this profile.
  ///It shouldn't change for default profiles, but it must be changed for testing purposes.
  late var firestore = FirebaseFirestore.instance;

  //In the database publicScore and private score are stored as collections
  ///The parameter publicScore represents a Map of the stored public scores.
  ///These scores are only collected from quizzes in public categories.
  ///For example, if the profile scored 13 points in the Science category,
  ///privateScore would contain 'Science':13.
  Map<String, dynamic> publicScore = {};

  ///The parameter privatecScore represents a Map of the stored private scores.
  //////These scores are only collected from quizzes in private categories.
  ///For example, if the profile scored 13 points in the Science category,
  ///privateScore would contain 'Science':13.
  Map<String, dynamic> privatecScore = {};

  Profile({
    required this.username,
    required this.email,
    this.firstName = '',
    this.lastName = '',
    this.profilePicture = '',
    this.bio = '',
    this.age = 0,
    this.birthdayMonth = '',
    this.birthdayDay = 0,
  }) {
    uid = getCurrentUserID();
  }

  ///This constructor is used only for unit tests
  Profile.test({
    required this.username,
    required this.email,
    this.firstName = '',
    this.lastName = '',
    this.profilePicture = '',
    this.bio = '',
    this.age = 0,
    this.birthdayMonth = '',
    this.birthdayDay = 0,
    required this.firestore,
    this.test = true,
  }) {
    uid = "mockedyouu";
  }

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
        email = json['email'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        profilePicture = json['profilePicture'],
        bio = json['bio'],
        age = json['age'],
        birthdayMonth = json['birthdayMonth'],
        birthdayDay = json['birthdayDay'],
        privatecScore = json['privateScore'],
        publicScore = json['scores'];

  @override
  String toString() {
    return 'User{ username: $username, firstName: $firstName, lastName: $lastName, bio: $bio, age: $age, }';
  }

  /// converts user object to json object
  Map<String, dynamic> toJson() => {
        'username': username,
        'lastName': lastName,
        'firstName': firstName,
        'profilePicture': profilePicture,
        'email': email,
        'bio': bio,
        'age': age,
        'birthdayMonth': birthdayMonth,
        'birthdayDay': birthdayDay,
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
      // create the document for categories created by the user
      print(uid);
      print(getCurrentUserID());
      await this
          .firestore
          .collection('categories')
          .doc(getCurrentUserID())
          .set({});

      await firestore
          .collection('users')
          .doc(getCurrentUserID())
          .set(this.toJson());
      UserStatistics s = UserStatistics(this.username, []);
      //Adding the user to the statistics
      Map<String, dynamic> data = {};
      await firestore.collection('UserStatistics').doc(this.username).set(data);
      return true;
    }

    return false;
  }

  /// gets the current profile from user uid
  /// [uid] is the firebase user uid
  /// returns a [Profile] instance
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

  /// Increment the score of the user in the firebase by the score achieved in the current quiz.
  Future<void> updateScore(String category, int score, bool is_public) async {
    if (await getCurrentUserID() == null ||
        await getCurrentUserUsername() == null) {
      throw UserNotLoggedInException();
    }

    final firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore.collection('users').doc(getCurrentUserID()).update({
      'scores.$category': FieldValue.increment(score),
    });
    //TODO

    Leaderboard leaderboard;
    if (is_public) {
      leaderboard = await Leaderboard.createPublic(
          category, (await getCurrentUserUsername())!);
    } else {
      leaderboard = await Leaderboard.createPrivate(
          category, (await getCurrentUserUsername())!);
    }
    leaderboard.updateCurrentUserPoints(score);
  }

  //START OF METHODS FOR PROFILE VIEW
  ///Updates the user's username in the Firebase Database.
  ///It takes [newUsername] as a parameter which is the value the current username will change to.
  ///It returns true if the username was updated successfully
  ///and false if the username was not updated successfully.
  bool updateUsername(String newUsername) {
    try {
      firestore
          .collection('users')
          .doc(test ? uid : getCurrentUserID())
          .update({'username': newUsername});

      return true;
    } catch (e) {
      return false;
    }
  }

  ///updates the bio information of the user in the Firebase Database.
  ///It takes [newBio] as a new parameter which is the value the current bio will change to.
  ///It returns true if the bio was updated successfully
  ///and false if the bio was not updated successfully.
  bool updateBio(String newBio) {
    try {
      firestore
          .collection('users')
          .doc(test ? uid : getCurrentUserID())
          .update({'bio': newBio});

      return true;
    } catch (e) {
      return false;
    }
  }

  ///Updates the first and lastname of the user in the Firebase Database
  ///It takes [newFirstName] and [newLastName] as parameters.
  ///[newFirstName] is the value the current first name will change to.
  ///[newLastName] is the value the current last name will change to.
  ///It returns true if the first and last name was updated successfully
  ///and false if the first and last name was not updated successfully.
  bool updateName(String newFirstName, String newLastName) {
    try {
      firestore
          .collection('users')
          .doc(test ? uid : getCurrentUserID())
          .update({'firstName': newFirstName, 'lastName': newLastName});

      return true;
    } catch (e) {
      return false;
    }
  }

  ///updates the birthday of the user in the Firebase Database
  ///It takes [newMonth] and [newDay] as parameters.
  ///[newMonth] is the value the current birthdayMonth will change to.
  ///[newDay] is the value the current birthdayDay will change to.
  ///It returns true if the birthday was updated successfully
  ///and false if the birthday was not updated successfully.
  bool updateBirthday(String newMonth, int newDay) {
    try {
      firestore
          .collection('users')
          .doc(test ? uid : getCurrentUserID())
          .update({'birthdayMonth': newMonth, 'birthdayDay': newDay});

      return true;
    } catch (e) {
      return false;
    }
  }

  ///updates the email of the user in the Firebase Database.
  ///It reauthenticates the user before updating the email to avoid errors with Firebase Authentication.
  ///It takes [currentEmail], [newEmail] and [password] as parameters.
  ///[currentEmail] is the current email of the user. It is used to reauthenticate the user.
  ///[newEmail] is the value the current email will change to.
  ///[password] is the current password of the user. It is used to reauthenticate the user.
  ///It returns true if the email was updated successfully
  ///and false if the email was not updated successfully.
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

  ///Updates the password of the user in the Firebase Database.
  ///It reauthenticates the user before updating the email to avoid errors with Firebase Authentication.
  ///[email] is the current email of the user. It is used to reauthenticate the user.
  ///[currentPassword] is the current password of the user. It is used to reauthenticate the user.
  ///[newPassword] is the value the current password will change to.
  ///It returns true if the password was updated successfully
  ///and false if the password was not updated successfully.
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

  ///Signs out the user from the system.
  ///It returns true if the user is signed out successfully
  ///and false if the user couldn't be signed out.
  bool signOut() {
    try {
      FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  ///Deletes the account of the user from the Firebase Database.
  ///[email] is the current email of the user. It is used to reauthenticate the user.
  ///[password] is the current password of the user. It is used to reauthenticate the user.
  ///It returns true if the account is deleted successfully
  ///and false if the account couldn't be deleted.
  Future<bool> deleteAccount(String email, String password) async {
    try {
      // delete all categories that this user created. In the collection 'categories',
      // get the document with the id=id of the user, find all categories and delete them
      List<String> categories = await CategoryRepo().getPrivateCategories();
      for (String category in categories) {
        await CategoryRepo().deleteCategory(category);
      }
      await CategoryRepo().deleteUserCollection();

      // delete all record in all public leaderboards where the user appears
      categories = await CategoryRepo().getPublicCategories();
      for (String category in categories) {
        Leaderboard leaderboard = await Leaderboard.createPublic(
            category, (await getCurrentUserUsername())!);
        await leaderboard.removeUserFromPublicLeaderboards();
        await leaderboard.removeUserFromAllLeaderboard();
      }

      firestore
          .collection('users')
          .doc(test ? uid : getCurrentUserID())
          .delete();
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

  ///Updates the Profile Picture of the user in the Firebase Database and in the Firebase Storage.
  ///The new image's reference is stored in Firebase Storage with the current user's uid
  ///and the link to the pictue is stored in the current user's Firebase Database document.
  ///It returns true if the picture was updated successfully
  ///and false if the picture was not updated successfully.
  Future<void> pickProfileImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );
    Reference ref =
        FirebaseStorage.instance.ref().child("profilePictures/${uid}");
    final fileBytes = await image!.readAsBytes();
    try {
      await ref.putData(fileBytes);
      ref.getDownloadURL().then((value) {
        print(value);
        firestore
            .collection('users')
            .doc(uid)
            .update({'profilePicture': value});
      });
    } catch (e) {
      print(e);
    }
  }
  //END OF METHODS FOR PROFILE VIEW

  static Future<List<Quiz>> getUserQuizzes({FirebaseFirestore? firestore}) async {
    List<Quiz> quizzes = [];
    Quiz temp = Quiz();
    String? uid;

    if (firestore == null) {
      firestore = FirebaseFirestore.instance;
      uid = await getCurrentUserID();
    }
    else {
      uid = "test123456789";
    }

    await firestore
        .collection('quizzes')
        .where('creatorID', isEqualTo: uid)
        .get()
        .then((QuerySnapshot querySnapshot) async{
      querySnapshot.docs.forEach((doc) async {
        await temp.fromJSON(doc.data() as Map<String, dynamic>);
        quizzes.add(temp);
      });
    });

    return quizzes;
  }
}
