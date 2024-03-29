import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../services/auth.dart';
import '../../model/profile.dart';

///This is controller for RegisterView
class RegisterViewController {
  ///[errorMessage] string parameter to store the error message caused by methods
  String errorMessage = "";

  ///constructor
  RegisterViewController();

  ///The [signUp] method creates a new Profile and registers it. It takes
  ///an [email], the user's email address,
  ///a [username], the user's username, and
  ///a [password], the user's password.
  ///It returnns true if the new user has been successfully entered into the database
  ///and returns false if the registration failed.
  Future<bool> signUp(String email, String username, String password) async {
    Profile newUser = Profile(
      username: username,
      email: email,
    );
    try {
      // always use register user with try catch since it throws
      // user already exists exception if the user already exists

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      Auth a = Auth();
      await a.signInWithEmailAndPassword(
          email: newUser.email, password: password);
      return await newUser.registerUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        errorMessage = "User already exists";
        print('User already exists');
        return false;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return false;
      } else {
        print("Something went wrong");
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  ///The [signInWithGoogle] method allows the user to register via Google.
  ///It takes the current build [context] as a parameter
  ///and returns the created [User] object upon completion.
  ///It authenticates with Google and registers the user with the profile model.
  Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (MediaQuery.of(context).size.width > 700) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            // handle the error here
            print(e);
          } else if (e.code == 'invalid-credential') {
            // handle the error here
            print(e);
          }
        } catch (e) {
          // handle the error here
          print(e);
        }
      }
    }
    Random rand = Random();
    String? usernamen;
    String? email;
    if (user != null) {
      if (user.email != null) {
        usernamen = user.email;

        email = user.email;
      }
    }
    String username = "default" + rand.nextInt(10000).toString();
    if (usernamen != null) {
      username = usernamen;
      username = username.substring(0, username.indexOf("@"));
    }
    if (email != null) {
      Profile newUser = Profile(
        username: username,
        email: email,
      );
      try {
        await newUser.registerUser();
      } catch (e) {
        print(e);
      }
    }
    return user;
  }

  ///The [signInWithFacebook] method allows the user to register via Google.
  ///It takes the current build [context] as a parameter
  ///and returns the created [User] object upon completion.
  ///It authenticates with Google and registers the user with the profile model.
  Future<User?> signInWithFacebook({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (MediaQuery.of(context).size.width > 700) {
      FacebookAuthProvider authProvider = FacebookAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final facebookLoginResult = await FacebookAuth.instance.login();

      if (facebookLoginResult != null) {
        final userData = await FacebookAuth.instance.getUserData();

        final facebookAuthCredential = FacebookAuthProvider.credential(
            facebookLoginResult.accessToken!.token);
        await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(facebookAuthCredential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            // handle the error here
            print(e);
          } else if (e.code == 'invalid-credential') {
            // handle the error here
            print(e);
          }
        } catch (e) {
          // handle the error here
          print(e);
        }
      }
    }
    Random rand = Random();
    String? usernamen;
    String? email;
    if (user != null) {
      if (user.email != null) {
        usernamen = user.email;

        email = user.email;
      }
    }
    String username = "default" + rand.nextInt(10000).toString();
    if (usernamen != null) {
      username = usernamen;
      username = username.substring(0, username.indexOf("@"));
    }
    if (email != null) {
      Profile newUser = Profile(
        username: username,
        email: email,
      );
      try {
        await newUser.registerUser();
      } catch (e) {
        print(e);
      }
    }
    return user;
  }
}
