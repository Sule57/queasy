import 'package:queasy/model/user.dart';

class ProfileViewController {
  ///@param [player] For now a dummy data used as a user
  final Profile player = Profile(
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
  bool editUsername(String currentUsername, String newUsername) {
    return player.updateUsername(currentUsername, newUsername);
  }

  ///changes the [currentEmail] with the given [newEmail] and confirms it through [password]
  bool editEmail(String currentEmail, String newEmail, String password) {
    return player.updateEmail(currentEmail, newEmail, password);
  }

  ///changes the current name with the given [newFirstname] and [newLastname] and requires [username]
  bool editName(String username, String newFirstname, String newLastname) {
    return player.updateName(username, newFirstname, newLastname);
  }

  ///changes the current bio with the given [newBio] and requires [username]
  bool editBio(String username, String newBio) {
    return player.updateBio(username, newBio);
  }

  ///changes the current profile picture with the given [newPic]
  void editProfilePic(String newPic) {
    player.profilePicture = newPic;
  }

  ///changes the current password [currentPassword] with the given [newPassword] and confirms it through [email]
  bool editPassword(String currentPassword, String newPassword, String email) {
    return player.updatePassword(email, currentPassword, newPassword);
  }

  ///deletes the account by confirming it via [email] and [password]
  bool deleteAccount(String email, String password) {
    return player.deleteAccount(email, password);
  }

  ///signs out of the account
  bool signOut() {
    return player.signOut();
  }
}
