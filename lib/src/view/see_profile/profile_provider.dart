import 'package:flutter/material.dart';

import '../../model/profile.dart';

class ProfileProvider with ChangeNotifier {
  late String currentUID;

  ///@param [player] For now a dummy data used as a user
  Profile player = Profile(
      username: "",
      email: "",
      firstName: "",
      lastName: "",
      bio: "",
      birthdayMonth: "",
      birthdayDay: 1,
      profilePicture: "");

  Profile get user => player;
  String get username => player.username;
  String get bio => player.bio.toString();
  String get firstName => player.firstName.toString();
  String get lastName => player.lastName.toString();
  String get email => player.email;
  String get profilePicture => player.profilePicture.toString();
  String get birthdayMonth => player.birthdayMonth.toString();
  int? get birthdayDay => player.birthdayDay;
  Map<String, dynamic> get scores => player.publicScore;

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

  Future<bool> updateProfile() async {
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

  List<double> getGraphData() {
    List<double> data = [];
    data.add(0.0);
    for (var value in player.publicScore.values) {
      data.add(value / 1000);
    }
    return data;
  }

  List<String> getGraphKeys() {
    List<String> data = [];
    data.add("");
    for (var value in player.publicScore.keys) {
      data.add(value);
    }
    print(data);
    return data;
  }
}
