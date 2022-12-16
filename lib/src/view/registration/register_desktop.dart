import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:queasy/constants/app_themes.dart';
import 'package:queasy/src/view/registration/register_view_controller.dart';
import 'package:queasy/services/auth.dart';
import 'package:queasy/src/view/home_view.dart';

class RegisterDesktop extends StatefulWidget {
  ///[controller] register-view controller
  final RegisterViewController controller = RegisterViewController();

  RegisterDesktop({Key? key}) : super(key: key);

  @override
  State<RegisterDesktop> createState() => _RegisterDesktopState();
}

class _RegisterDesktopState extends State<RegisterDesktop> {
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
                      color: white,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))))),
          SingleChildScrollView(
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
                          bottom: MediaQuery.of(context).size.height * .05),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * .10,
                        ),
                      ),
                    ),
                    TextFormField(
                      ///if the user hasn't entered anything, validation fails
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        return null;
                      },
                      controller: controllerEmail,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(),
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
                          labelText: 'Username',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(),
                      child: TextFormField(
                        ///hides/shows password based on user click
                        obscureText: !passwordVisible,

                        ///if the user hasn't entered anything, validation fails
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                        controller: controllerPassword,
                        decoration: InputDecoration(
                          labelText: 'Password',

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
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * .05),
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
                          labelText: 'Confirm Password',

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
                          if (formKey.currentState!.validate()) {
                            bool success = await controller.signUp(
                              controllerEmail.text,
                              controllerUsername.text,
                              controllerPassword.text,
                            );
                            if (success) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const HomeView()));
                            } else {
                              print(errorMessage);
                            }
                          }
                        }),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
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
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 14.0),
                            child: const Divider(
                                color: Colors.grey, height: 36, thickness: 1.0),
                          ),
                        ),
                        const Text("or", style: TextStyle(fontSize: 16.0)),
                        Expanded(
                          child: Container(
                            margin:
                                const EdgeInsets.only(left: 14.0, right: 10.0),
                            child: const Divider(
                                color: Colors.grey, height: 36, thickness: 1.0),
                          ),
                        ),
                      ],
                    ),

                    /// Here the user can see different options to create an account.
                    /// This [Row] displays the social media sign up buttons.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Image.asset('lib/assets/images/google.png'),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Image.asset(
                            'lib/assets/images/facebook.png',
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
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
                    color: white,
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
