import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    notifyListeners();
  }

  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> signInWithGoogle() async {
    final GoogleAuthProvider googleProvider = GoogleAuthProvider();

    if (kIsWeb) {
      await _firebaseAuth.signInWithPopup(googleProvider);
    } else {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // return await FirebaseAuth.instance.signInWithCredential(credential);
    }
  }

  Future<void> signInWithFacebook() async {
    final FacebookAuthProvider facebookProvider = FacebookAuthProvider();

    if (kIsWeb) {
      await _firebaseAuth.signInWithPopup(facebookProvider);
    } else {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
    }
  }

  Future<void> signInWithTwitter() async {
    final TwitterAuthProvider twitterProvider = TwitterAuthProvider();

    if (kIsWeb) {
      await _firebaseAuth.signInWithPopup(twitterProvider);
    } else {
      //TODO implement mobile sign in
    }
    //TODO register user in firestore with email and give him a choice for username
  }

  /// Sends a password reset email to the user with the given [emailAddress].
  void sendPasswordResetEmail(String emailAddress) async {
    await _firebaseAuth.sendPasswordResetEmail(email: emailAddress);
  }
}
