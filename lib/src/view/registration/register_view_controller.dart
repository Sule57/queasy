import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../services/auth.dart';
import '../../model/profile.dart';

///This is controller for RegisterView
class RegisterViewController {


  ///constructor
  RegisterViewController();

  ///signUp method creates a new Profile and registers it
  ///[email] the user's email address
  ///[username] the user's username
  ///[password] the user's password
  ///@return true -> the new user has been successfully entered into the database
  ///@return false -> registration failed
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
      a.signInWithEmailAndPassword(
          email: newUser.email, password: password);
      return await newUser.registerUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
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

  ///signInWithGoogle method allows the user to register via Google
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
    if(user != null) {
      if(user.email != null){
        usernamen = user.email;

        email = user.email;
      }
    }
    String username = "default" + rand.nextInt(10000).toString();
    if(usernamen != null) {
      username = usernamen;
      username = username.substring(0, username.indexOf("@"));
    }
    if(email != null) {
      Profile newUser = Profile(
        username: username,
        email: email,
      );
      try {
        await newUser.registerUser();
      }catch(e){
        print(e);
      }
    }
    return user;
  }
}
