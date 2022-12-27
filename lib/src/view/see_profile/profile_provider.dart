import 'package:flutter/material.dart';

import '../../model/profile.dart';

class ProfileProvider with ChangeNotifier {
  late String currentUID;

  ///@param [player] For now a dummy data used as a user
  Profile player = Profile(
      username: "Dummy",
      email: "dummy@gmail.com",
      hashPassword: "dummyPassword",
      firstName: "Dummy",
      lastName: "Whatever",
      bio: "Dummy likes playing quizzes",
      birthdayMonth: 'January',
      birthdayDay: 1,
      profilePicture: "https://www.peakpx.com/en/hd-wallpaper-desktop-vsviy");

  Profile get user => player;
  String get username => player.username;
  String get bio => player.bio.toString();
  String get firstName => player.firstName.toString();
  String get lastName => player.lastName.toString();
  String get email => player.email;
  String get profilePicture => player.profilePicture.toString();
  String get birthdayMonth => player.birthdayMonth.toString();
  int? get birthdayDay => player.birthdayDay;

  ProfileProvider() {}

  Future<bool> setProfile() async {
    if (getCurrentUserID() != null) {
      currentUID = getCurrentUserID()!;
      Profile? p = await Profile.getProfilefromUID(currentUID);
      if (p != null) {
        player = p;
        notifyListeners();
        return true;
      }
    }
    return false;
  }
}
