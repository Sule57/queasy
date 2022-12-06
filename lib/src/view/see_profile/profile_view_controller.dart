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

  ///[success] a list that collects returned values of edit methods
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
  ///and the value is added to the [success] list
  void editUsername(String currentUsername, String newUsername) {
    success = [
      ...success,
      player.updateUsername(
          currentUsername, newUsername, FirebaseFirestore.instance)
    ];
  }

  ///changes the [currentEmail] with the given [newEmail] and confirms it through [password]
  ///and the value is added to the [success] list
  void editEmail(String currentEmail, String newEmail, String password) {
    success = [
      ...success,
      player.updateEmail(currentEmail, newEmail, password)
    ];
  }

  ///changes the current name with the given [newFirstname] and [newLastname] and requires [username]
  ///and the value is added to the [success] list
  void editName(String username, String newFirstname, String newLastname) {
    success = [
      ...success,
      player.updateName(
          username, newFirstname, newLastname, FirebaseFirestore.instance)
    ];
  }

  ///changes the current bio with the given [newBio] and requires [username]
  ///and the value is added to the [success] list
  void editBio(String username, String newBio) {
    success = [
      ...success,
      player.updateBio(username, newBio, FirebaseFirestore.instance)
    ];
  }

  ///changes the current profile picture with the given [newPic]
  ///and the value is added to the [success] list
  void editProfilePic(String newPic) {
    success = [
      ...success,
      player.updatePicture(username, newPic, FirebaseFirestore.instance)
    ];
  }

  ///changes the current password [currentPassword] with the given [newPassword] and confirms it through [email]
  ///and the value is added to the [success] list
  void editPassword(String currentPassword, String newPassword, String email) {
    success = [
      ...success,
      player.updatePassword(email, currentPassword, newPassword)
    ];
  }

  ///deletes the account by confirming it via [email] and [password]
  ///and the value is added to the [success] list
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

  ///this is the method that is called in profile views (both mobile and desktop)
  ///@return true -> edit was successful
  ///@return false -> edit failed
  ///[currentPassword] is required to edit user profile
  bool editAllProfile(String currentPassword) {
    ///if [success] list is empty, editing fails
    ///if [success] list contains false, it means one of the edit methods failed so editing as a whole fails
    ///if [currentPassword] is not provided, editing fails
    if (success.isNotEmpty &&
        !success.contains(false) &&
        currentPassword.isNotEmpty) {
      ///the list is reset
      success.clear();
      return true;
    }

    ///if [success] list is not empty, list is cleared for reset
    if (success.isNotEmpty) {
      success.clear();
    }
    return false;
  }
}
