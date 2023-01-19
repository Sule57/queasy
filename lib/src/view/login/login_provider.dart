/// ****************************************************************************
/// Created by Julia Agüero
/// Collaborators: Gullu Gasimova
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:queasy/services/auth.dart';
import 'package:queasy/src/view/login/login_view.dart';
import 'widgets/forgot_password_dialog.dart';

/// A class that is used to store the logic of the [LoginView].
///
/// It contains all the functions that are used to validate the user input and to
/// sign in the user. It also contains the text controllers for the text fields
/// used both in [LoginViewMobile] and [LoginViewDesktop].
///
/// It is a provider since it uses the class [ChangeNotifier]. This means every
/// widget that are listening to this provider will be rebuild when the state of
/// any of the variables inside of this class changes.
class LoginProvider with ChangeNotifier {
  /// Variable used to store the error messages that are shown to the user when
  /// they try to sign in.
  String? _errorMessage = '';

  /// Getter for [_errorMessage] of type nullable [String].
  get errorMessage => _errorMessage;

  /// Key used in the [LoginViewMobile] to validate the email and password
  /// fields before the form is sent.
  var loginFormKeyMobile = GlobalKey<FormState>();

  /// Key used in the [LoginViewDesktop] to validate the email and password
  /// fields before the form is sent.
  var loginFormKeyDesktop = GlobalKey<FormState>();

  /// Key used in the [ForgotPasswordDialog] to validate the email field before
  /// the form is sent.
  var forgotPasswordFormKey = GlobalKey<FormState>();

  /// Text controller used to store the email that the user enters in the
  /// [LoginViewMobile] and [LoginViewDesktop].
  late TextEditingController emailController;

  /// Text controller used to store the password that the user enters in the
  /// [LoginViewMobile] and [LoginViewDesktop].
  late TextEditingController passwordController;

  /// Text controller used to store the email that the user enters in the
  /// [ForgotPasswordDialog].
  late TextEditingController forgotPasswordController;

  /// Value used to store user's preferences about their password being shown.
  /// When the value is true, the password is hidden so the screen does not
  /// show the actual characters. When the value is false, the password is shown
  /// so the user can see what they are typing.
  bool _isPasswordObscured = true;

  /// Getter for [_isPasswordObscured] of type [bool].
  get isPasswordObscured => _isPasswordObscured;

  /// Restarts the values of the keys used to validate the forms in order to
  /// avoid errors of duplicate keys in widget tree.
  void restartKeys() {
    this.loginFormKeyDesktop = new GlobalKey<FormState>();
    this.loginFormKeyMobile = new GlobalKey<FormState>();
    this.forgotPasswordFormKey = new GlobalKey<FormState>();
  }

  /// Toggles the value of [_isPasswordObscured] between true and false.
  void togglePasswordVisibility() {
    _isPasswordObscured = !_isPasswordObscured;
    notifyListeners();
  }

  /// Signs in the user using the email and password that they entered in the
  /// [LoginViewMobile] and [LoginViewDesktop].
  ///
  /// Called when the user presses the "Sign in" button. It validates the email
  ///
  Future<bool> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      await Auth().signInWithGoogle();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithFacebook() async {
    try {
      await Auth().signInWithFacebook();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithTwitter() async {
    try {
      await Auth().signInWithTwitter();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
      return false;
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  void sendForgotPasswordEmail() {
    Auth().sendPasswordResetEmail(forgotPasswordController.text);
  }
}
