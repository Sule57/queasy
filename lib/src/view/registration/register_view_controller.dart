import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/auth.dart';
import '../../model/profile.dart';

///This is controller for RegisterView
class RegisterViewController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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
      hashPassword: password,
    );
    try {
      // always use register user with try catch since it throws
      // user already exists exception if the user already exists

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password
        );
      Auth a = Auth();
      a.signInWithEmailAndPassword(email: newUser.email, password: newUser.hashPassword);
      return newUser.registerUser();
    }  on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return false;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return false;
      }else{
        print("Something went wrong");
        return false;
      }
    }
    catch (e) {
      print(e.toString());
      return false;
    }
  }
}
