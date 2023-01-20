/// ****************************************************************************
/// Created by Gullu Gasimova
/// Collaborators: Julia Agüero
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/constants/theme_provider.dart';
import 'package:queasy/src/view/login/widgets/login_info.dart';

import 'login_provider.dart';

/// This is the mobile version of the login view.
///
/// It is the view that the user sees when they are trying to sign in to
/// use the app. It shows two fields for the user to fill in, and a button
/// to sign up. When the login is completed, the user is taken to [HomeView].
class LoginView extends StatefulWidget {
  /// Constructor for the [LoginView].
  LoginView({Key? key}) : super(key: key);

  /// Creates the state for this widget.
  @override
  State<LoginView> createState() => _LoginViewState();
}

/// State for [LoginView].
class _LoginViewState extends State<LoginView> {
  /// Controller used to store all the logic of the [LoginView]. It contains all
  /// the functions that are used to validate the user input and to sign in the
  /// user.
  late LoginProvider controller;

  /// Called when the view is build for the first time. It initializes the
  /// [controller] and the text fields inside of it.
  @override
  void initState() {
    controller = Provider.of<LoginProvider>(context, listen: false);
    controller.forgotPasswordController = TextEditingController();
    controller.passwordController = TextEditingController();
    controller.emailController = TextEditingController();
    super.initState();
  }

  /// Called when the view is disposed. It disposes the text fields inside of
  /// [controller].
  @override
  void dispose() {
    controller.forgotPasswordController.dispose();
    controller.passwordController.dispose();
    controller.emailController.dispose();
    controller.restartKeys();
    super.dispose();
  }

  /// Builds the view.
  ///
  /// It checks if the width of the screen is greater than 800. If it is,
  /// it returns the [LoginViewDesktop]. If it is smaller, it returns the
  /// [LoginViewMobile].
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width > 700.0 ? LoginViewDesktop() : LoginViewMobile();
  }
}

/// It is the mobile version of the login view.
///
/// It is the view that the user sees when they are trying to sign in to
/// use the app from a mobile device or a web explorer with a screen smaller
/// than 800 points. It displays the logo of the app and the login form
/// as a column.
class LoginViewMobile extends StatelessWidget {
  const LoginViewMobile({Key? key}) : super(key: key);

  /// Builds the view.
  ///
  /// Shows the fields inside of a scrollable column with padding. Everything
  /// is contained inside of a [SafeArea] widget in order to avoid the notch
  /// of the iPhone.
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    double verticalPadding = height / 20;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 20),
          child: SingleChildScrollView(
            child: Container(
              height: height - verticalPadding * 2,
              constraints: BoxConstraints(
                minHeight: 550,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/images/logo_vertical.png',
                    height: height / 4,
                    fit: BoxFit.fitHeight,
                  ),
                  SizedBox(height: 10),
                  Expanded(child: LoginInfo()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// It is the desktop version of the login view.
///
/// It is the view that the user sees when they are trying to sign in to
/// use the app from a desktop device or a web explorer with a screen greater
/// than 800 points. It displays the logo of the app and the login form
/// as a row, with a colorful background.
class LoginViewDesktop extends StatelessWidget {
  const LoginViewDesktop({Key? key}) : super(key: key);

  /// Builds the view.
  ///
  /// Shows the fields in a row, with the logo on the left and the login form
  /// on the right. Everything is displayed on top of [DesktopBackground].
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextStyle? titleTextStyle = Provider.of<ThemeProvider>(context)
        .currentTheme
        .textTheme
        .headline1
        ?.copyWith(
          height: 1,
        );

    return Scaffold(
      body: Stack(
        children: [
          DesktopBackground(),
          Center(
            child: Container(
              height: height / 1.5,
              width: width / 0.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'lib/assets/images/logo_vertical.png',
                      width: width / 3,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: width / 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Log in',
                          style: titleTextStyle,
                        ),
                        LoginInfo(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// It is the background of the [LoginViewDesktop].
///
/// It is a widget that shows some colorful containers with the main colors
/// of the app.
class DesktopBackground extends StatelessWidget {
  const DesktopBackground({Key? key}) : super(key: key);

  /// Builds the view.
  ///
  /// Shows the containers in a stack.
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<ThemeProvider>(context).currentTheme;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Container(
            height: height / 1.7,
            width: width / 5.5,
            decoration: BoxDecoration(
              color: themeProvider.colorScheme.secondary,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: height * .25,
              width: width / 2.1,
              decoration: BoxDecoration(
                  color: themeProvider.colorScheme.tertiary,
                  borderRadius:
                      const BorderRadius.only(topRight: Radius.circular(20))),
            ),
          ),
          Positioned(
            left: 0,
            bottom: height / 5.4,
            child: Container(
              height: height * .35,
              width: width / 10,
              decoration: BoxDecoration(
                color: themeProvider.colorScheme.onTertiary,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              height: height / 4.5,
              width: width / 4,
              decoration: BoxDecoration(
                color: themeProvider.colorScheme.onTertiary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
