/// ****************************************************************************
/// Created by Endia Clark
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************
import 'package:flutter/material.dart';

import '../../model/profile.dart';

/// This class is responsible for managing the data on the profile view.
///
/// The late field [currentUID] stores the UID of the current player
/// after the provider is initialized.
///
/// The parameter [player] is the player that is being displayed by the view.
class ProfileProvider with ChangeNotifier {
  late String currentUID;

  ///[player] For now a dummy data used as a user
  Profile player = Profile(
      username: "",
      email: "",
      firstName: "",
      lastName: "",
      bio: "",
      birthdayMonth: "",
      birthdayDay: 1,
      profilePicture: "");

  ///getter methods for user data
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

  ///Sets the [player] parameter with current user information from the [Profile] model.
  ///Should be called when a view need the [ProfileProvider] is being initialized.
  Future<bool> setProfile() async {
    if (await getCurrentUserID() != null) {
      currentUID = await getCurrentUserID()!;
      Profile? p = await Profile.getProfileFromUID(currentUID);
      if (p != null) {
        player = p;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  ///Updates the [player] parameter with current user information from the [Profile] model.
  ///Should be called when a view using the [ProfileProvider] needs to show updated information.
  Future<bool> updateProfile() async {
    if (getCurrentUserID() != null) {
      currentUID = getCurrentUserID()!;
      Profile? p = await Profile.getProfileFromUID(currentUID);
      if (p != null) {
        player = p;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  ///Returns the graph data of the [player] parameter as a List<double> so that it can be used by Widgets.
  List<double> getGraphData() {
    List<double> data = [];
    //data.add(0.0);
    for (var value in player.publicScore.values) {
      data.add(value + 0.0);
    }
    return data;
  }

  ///Returns the graph keys of the [player] parameter as a List<String> so that it can be used by Widgets.
  List<String> getGraphKeys() {
    List<String> data = [];
    //data.add("");
    for (var value in player.publicScore.keys) {
      data.add(value);
    }
    print(data);
    return data;
  }
}
