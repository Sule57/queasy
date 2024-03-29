import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:queasy/constants/app_themes.dart';
import 'package:queasy/src/view/registration/register_view_controller.dart';
import 'package:queasy/services/auth.dart';
import 'package:queasy/src/view/home_view.dart';

/// This is the register view for desktop.
class RegisterViewDesktop extends StatefulWidget {
  ///[controller] register-view controller
  final RegisterViewController controller = RegisterViewController();

  RegisterViewDesktop({Key? key}) : super(key: key);

  @override
  State<RegisterViewDesktop> createState() => _RegisterViewDesktopState();
}

class _RegisterViewDesktopState extends State<RegisterViewDesktop> {
  ///[controller] register-view controller
  get controller => widget.controller;

  ///[errorMessage] to show error received from firebase on the terminal
  String? errorMessage = '';

  ///[formKey] is registration form
  final formKey = GlobalKey<FormState>();

  ///a list of TextEditingControllers to receive user inputs:
  ///[controllerUsername], [controllerPassword], [controllerConfirmPassword], [controllerEmail]
  final TextEditingController controllerUsername = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final TextEditingController controllerConfirmPassword =
      TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();

  ///[_passwordVisible] are to hide/show the passwords
  bool passwordVisible = false;
  bool _isGoogleSigningIn = false;

  ///_isLoading is used to determine whether to allow the user to click the register button.
  ///This prevents double clicking leading to errors due to resubmitting the same data twice
  bool _isLoading = false;

  Future<bool> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: controllerUsername.text,
        password: controllerPassword.text,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 2.1,
                  right: MediaQuery.of(context).size.width / 45,
                  top: MediaQuery.of(context).size.height * .07,
                  bottom: MediaQuery.of(context).size.height * .07),
              child: Container(
                  height: MediaQuery.of(context).size.height * .90,
                  width: MediaQuery.of(context).size.width / 2.3,
                  decoration: BoxDecoration(
                      color: light,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))))),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 1.8,
                      right: MediaQuery.of(context).size.width / 10,
                      top: MediaQuery.of(context).size.height * .10,
                      bottom: MediaQuery.of(context).size.height * .10),
                  child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// The log in title
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.height * .05),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * .10,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: TextFormField(
                              ///if the user hasn't entered anything, validation fails
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter email';
                                }
                                if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  return "Invalid email address";
                                }
                                return null;
                              },
                              controller: controllerEmail,
                              decoration: const InputDecoration(
                                hintText: 'Email',
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: TextFormField(
                              ///if the user hasn't entered anything, validation fails
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter username';
                                }
                                return null;
                              },
                              controller: controllerUsername,
                              decoration: const InputDecoration(
                                hintText: 'Username',
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: TextFormField(
                              ///hides/shows password based on user click
                              obscureText: !passwordVisible,

                              ///if the user hasn't entered anything, validation fails
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter password';
                                }
                                if (value.length < 6) {
                                  return 'Password needs to be at least 6 characters';
                                }
                                return null;
                              },
                              controller: controllerPassword,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                filled: true,
                                fillColor: Colors.white,

                                ///[IconButton] to click when user wants to see/hide password
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: TextFormField(
                              ///hides/shows password based on user click
                              obscureText: !passwordVisible,

                              ///if the user hasn't entered anything, validation fails
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm password';
                                }

                                if (value.isNotEmpty &&
                                    value != controllerPassword.text) {
                                  return 'Passwords do not match';
                                }

                                return null;
                              },
                              controller: controllerConfirmPassword,
                              decoration: InputDecoration(
                                hintText: 'Confirm Password',
                                filled: true,
                                fillColor: Colors.white,

                                ///[IconButton] to click when user wants to see/hide password
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * .02,
                              left: MediaQuery.of(context).size.width / 13,
                              bottom: MediaQuery.of(context).size.height * .02,
                            ),
                            width: MediaQuery.of(context).size.width / 4,

                            ///Sign up button
                            child: ElevatedButton(
                              onPressed: (() async {
                                setState(() {
                                  _isLoading = true;
                                });
                                if (formKey.currentState!.validate()) {
                                  bool success = await controller.signUp(
                                    controllerEmail.text,
                                    controllerUsername.text,
                                    controllerPassword.text,
                                  );
                                  if (success) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeView()));
                                  } else {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    print(errorMessage);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(controller.errorMessage),
                                      ),
                                    );
                                  }
                                }
                              }),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ))),
                              child: const Text(
                                "Sign up",
                                style: TextStyle(fontSize: 23),
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 10.0, right: 14.0),
                                  child: const Divider(
                                      color: Colors.grey,
                                      height: 36,
                                      thickness: 1.0),
                                ),
                              ),
                              const Text("or",
                                  style: TextStyle(fontSize: 16.0)),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 14.0, right: 10.0),
                                  child: const Divider(
                                      color: Colors.grey,
                                      height: 36,
                                      thickness: 1.0),
                                ),
                              ),
                            ],
                          ),

                          /// Here the user can see different options to create an account.
                          /// This [Row] displays the social media sign up buttons.
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _isGoogleSigningIn
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    )
                                  : IconButton(
                                      icon: Image.asset(
                                          'lib/assets/images/google.png'),
                                      onPressed: () async {
                                        setState(() {
                                          _isGoogleSigningIn = true;
                                        });
                                        User? user = await controller
                                            .signInWithGoogle(context: context);
                                        setState(() {
                                          _isGoogleSigningIn = false;
                                        });
                                        if (user != null) {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) => HomeView(),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                              IconButton(
                                icon: Image.asset(
                                  'lib/assets/images/facebook.png',
                                ),
                                onPressed: () {},
                              ),
                              // IconButton(
                              //   icon: Image.asset(
                              //     'lib/assets/images/twitter.png',
                              //   ),
                              //   onPressed: () {},
                              // ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already a user? ",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: ElevatedButton(
                                  child: Text(
                                    'Log In',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    ),
                                  ),
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))),
                                  onPressed: () => {
                                    Navigator.of(context).pop(),
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 7,
                height: MediaQuery.of(context).size.height * .60,
                decoration: BoxDecoration(
                    color: orange,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(20))),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                height: MediaQuery.of(context).size.height * .25,
                width: MediaQuery.of(context).size.width / 2.1,
                decoration: BoxDecoration(
                    color: green,
                    borderRadius:
                        const BorderRadius.only(topRight: Radius.circular(20))),
              )
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * .30,
            ),
            child: Container(
                height: MediaQuery.of(context).size.height * .35,
                width: MediaQuery.of(context).size.width / 10,
                decoration: BoxDecoration(
                    color: light,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ))),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * .10,
              bottom: MediaQuery.of(context).size.height * .45,
              right: MediaQuery.of(context).size.width / 2.5,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 1,
              child: Image.asset(
                'lib/assets/images/logo_vertical.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
