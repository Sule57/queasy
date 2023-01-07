import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

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
      FirebaseAuth.instance.signOut();
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
      //TODO implement mobile sign in
    }
    //TODO register user in firestore with email and give him a choice for username
  }

  Future<void> signInWithFacebook() async {
    final FacebookAuthProvider facebookProvider = FacebookAuthProvider();

    if (kIsWeb) {
      await _firebaseAuth.signInWithPopup(facebookProvider);
    } else {
      //TODO implement mobile sign in
    }
    //TODO register user in firestore with email and give him a choice for username
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

  void sendPasswordResetEmail(String emailAddress) {
    //TODO implement
  }
}
