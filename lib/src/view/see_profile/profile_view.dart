import 'package:flutter/material.dart';
import 'package:queasy/src/view/see_profile/profile-desktop.dart';
import 'package:queasy/src/view/see_profile/profile-mobile.dart';

// class UserProfile extends StatefulWidget {
//   final ProfileViewController controller = ProfileViewController();

//   UserProfile({Key? key}) : super(key: key);

//   ///creates ProfileView class
//   @override
//   State<UserProfile> createState() => ProfileView();
// }

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width > 700
        ? UserProfileDesktop()
        : UserProfileMobile();
  }
}
