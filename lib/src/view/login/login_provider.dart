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

class LoginProvider with ChangeNotifier {
  String? _errorMessage = '';
  get errorMessage => _errorMessage;

  final loginFormKeyMobile =
      GlobalKey<FormState>(debugLabel: '_loginFormKeyMobile');
  final loginFormKeyDesktop =
      GlobalKey<FormState>(debugLabel: '_loginFormKeyDesktop');
  final forgotPasswordFormKey =
      GlobalKey<FormState>(debugLabel: '_forgotPasswordFormKey');

  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController forgotPasswordController;

  bool _isPasswordObscured = true;
  get isPasswordObscured => _isPasswordObscured;

  void togglePasswordVisibility() {
    _isPasswordObscured = !_isPasswordObscured;
    notifyListeners();
  }

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
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
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
