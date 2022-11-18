import 'package:queasy/model/user.dart';

class ProfileViewController {
  ///@param player For now a dummy data used as a user
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

  ///changes the current username with the given new [newUsername]
  void editUsername(String newUsername) {
    player.username = newUsername;
  }

  ///changes the current email with the given new [newEmail]
  void editEmail(String newEmail) {
    player.email = newEmail;
  }

  ///changes the current name with the given [newFirstname] and [newLastname]
  void editName(String newFirstname, String newLastname) {
    player.firstName = newFirstname;
    player.lastName = newLastname;
    //return player.lastName.toString();
  }

  ///changes the current bio with the given [newBio]
  void editBio(String newBio) {
    player.bio = newBio;
  }

  ///changes the current profile picture with the given [newPic]
  void editProfilePic(String newPic) {
    player.profilePicture = newPic;
  }

  ///changes the current password [oldPassword] with the given [newPassword]
  void editPassword(
      String oldPassword, String newPassword, String newPasswordConfirm) {}

  ///deletes the account
  void deleteAccount() {}

  ///signs out of the account
  void signOut() {}
}
