import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:queasy/src/view/registration/register_desktop.dart';
import 'package:queasy/src/view/registration/register_mobile.dart';

class RegisterView extends StatefulWidget {
  RegisterView({Key? key}) : super(key: key);

  ///creates RegisterViewState class
  @override
  State<RegisterView> createState() => RegisterViewState();
}

/// This is the register view state.
///
/// It is the view that the user sees when they are creating an account to
/// use the app.
class RegisterViewState extends State<RegisterView> {
  /// Builds the view.
  ///
  ///Depending on the width of the device that the app is on two different versions of register view are shown
  @override
  Widget build(BuildContext context) {
    ///if width of the device is less than 700 then UserProfileMobile is shown
    ///if more than 700 then the user sees UserProfileDesktop
    return MediaQuery.of(context).size.width > 700
        ? RegisterDesktop()
        : RegisterViewMobile();
  }
}
