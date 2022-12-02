import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queasy/src/model/profile.dart';

class ProfileViewController {
  ///@param [player] For now a dummy data used as a user
  Profile player = Profile(
      username: "Dummy",
      email: "dummy@gmail.com",
      hashPassword: "dummyPassword",
      firstName: "Dummy",
      lastName: "Whatever",
      age: 99,
      bio: "Dummy likes playing quizzes",
      profilePicture: "https://www.peakpx.com/en/hd-wallpaper-desktop-vsviy");

  ///constructor for the controller
  ProfileViewController();
  List<bool> success = new List.empty();

  ///getter methods for user data
  Profile get user => player;
  String get username => player.username;
  String get bio => player.bio.toString();
  String get firstName => player.firstName.toString();
  String get lastName => player.lastName.toString();
  String get email => player.email;
  String get profilePicture => player.profilePicture.toString();
  int? get age => player.age;

  ///changes the [currentUsername] with the given new [newUsername]
  void editUsername(String currentUsername, String newUsername) {
    success = [
      ...success,
      player.updateUsername(
          currentUsername, newUsername, FirebaseFirestore.instance)
    ];
  }

  ///changes the [currentEmail] with the given [newEmail] and confirms it through [password]
  void editEmail(String currentEmail, String newEmail, String password) {
    success = [
      ...success,
      player.updateEmail(currentEmail, newEmail, password)
    ];
  }

  ///changes the current name with the given [newFirstname] and [newLastname] and requires [username]
  void editName(String username, String newFirstname, String newLastname) {
    success = [
      ...success,
      player.updateName(
          username, newFirstname, newLastname, FirebaseFirestore.instance)
    ];
  }

  ///changes the current bio with the given [newBio] and requires [username]
  void editBio(String username, String newBio) {
    success = [
      ...success,
      player.updateBio(username, newBio, FirebaseFirestore.instance)
    ];
  }

  ///changes the current profile picture with the given [newPic]
  void editProfilePic(String newPic) {
    success = [
      ...success,
      player.updatePicture(username, newPic, FirebaseFirestore.instance)
    ];
  }

  ///changes the current password [currentPassword] with the given [newPassword] and confirms it through [email]
  void editPassword(String currentPassword, String newPassword, String email) {
    success = [
      ...success,
      player.updatePassword(email, currentPassword, newPassword)
    ];
  }

  ///deletes the account by confirming it via [email] and [password]
  bool deleteAccount(String email, String password) {
    if (email.isNotEmpty && password.isNotEmpty) {
      return player.deleteAccount(email, password);
    }
    return false;
  }

  ///signs out of the account
  bool signOut() {
    return player.signOut();
  }

  bool editAllProfile(String currentPassword) {
    if (success.isNotEmpty &&
        !success.contains(false) &&
        currentPassword.isNotEmpty) {
      success.clear();
      return true;
    }
    if (success.isNotEmpty) {
      success.clear();
    }
    return false;
  }
}
