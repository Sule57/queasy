import 'package:cloud_firestore/cloud_firestore.dart';
import '../src/model/profile.dart';

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

      return newUser.registerUser(firestore);
    }catch(e){
      print(e.toString()) ;
      return false;
    }
  }
}
