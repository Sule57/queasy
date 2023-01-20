/// ****************************************************************************
/// Created by Gullu Gasimova
/// Collaborator: Endia Clark
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************
import 'package:queasy/src/model/profile.dart';

/// The class provides data from the model to the [ProfileView].
/// the field [player] is used to store the current player's [Profile]. Allows the
/// contoller to call methds from the [Profile] model.
/// the field [success] is a list that collects returned values of edit methods.
class ProfileViewController {
  ///@param [player] For now a dummy data used as a user
  Profile player = Profile(
      username: "",
      email: "",
      firstName: "",
      lastName: "",
      age: 0,
      bio: "",
      profilePicture: "");

  ///constructor for the controller
  ProfileViewController();

  ///[success] a list that collects returned values of edit methods
  List<bool> success = [true];

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
  Future<void> editUsername(String newUsername) async {
    success = [...success, await player.updateUsername(newUsername)];
  }

  ///changes the [currentEmail] with the given [newEmail] and confirms it through [password]
  ///and the value is added to the [success] list
  Future<void> editEmail(
      String currentEmail, String newEmail, String password) async {
    success = [
      ...success,
      await player.updateEmail(currentEmail, newEmail, password)
    ];
  }

  ///changes the current name with the given [newFirstname] and [newLastname] and requires [username]
  ///and the valufe is added to the [success] list
  Future<void> editName(String newFirstname, String newLastname) async {
    success = [...success, await player.updateName(newFirstname, newLastname)];
  }

  ///changes the current bio with the given [newBio] and requires [username]
  ///and the value is added to the [success] list
  Future<void> editBio(String newBio) async {
    success = [...success, await player.updateBio(newBio)];
  }

  ///changes the current password [currentPassword] with the given [newPassword] and confirms it through [email]
  ///and the value is added to the [success] list
  Future<void> editPassword(
      String currentPassword, String newPassword, String email) async {
    success = [
      ...success,
      await player.updatePassword(email, currentPassword, newPassword)
    ];
  }

  ///deletes the account by confirming it via [email] and [password]
  ///and the value is added to the [success] list
  Future<bool> deleteAccount(String email, String password) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      return await player.deleteAccount(email, password);
    }
    return false;
  }

  ///signs out of the account
  Future<bool> signOut() async {
    return await player.signOut();
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

  ///Calls the pickProfileImage method in the profile model.
  ///Returns true if the model's function is successful and
  ///false otherwise.
  Future<bool> pickProfilePicture() async {
    try {
      await player.pickProfileImage();
      return true;
    } catch (e) {
      return false;
    }
  }
}
