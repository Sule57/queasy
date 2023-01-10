import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:queasy/src/view/registration/register_view_controller.dart';
import 'package:queasy/src/view/home_view.dart';

class RegisterViewMobile extends StatefulWidget {
  ///[controller] register-view controller
  final RegisterViewController controller = RegisterViewController();

  RegisterViewMobile({Key? key}) : super(key: key);

  ///creates RegisterViewState class
  @override
  State<RegisterViewMobile> createState() => RegisterViewMobileState();
}

/// This is the register view state.
///
/// It is the view that the user sees when they are creating an account to
/// use the app. It shows four fields for the user to fill in, and a button
/// to sign up. When the registration is over, the user is taken to [HomeView].
/// It uses colors from [AppThemes].
class RegisterViewMobileState extends State<RegisterViewMobile> {

  ///[controller] register-view controller
  get controller => widget.controller;

  ///[_passwordVisible] and [_confirmPasswordVisible] are to hide/show the passwords
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  ///[formKey] is registration form
  final formKey = GlobalKey<FormState>();

  ///[textController] a list of TextEditingControllers to receive user inputs
  List<TextEditingController> textController =
      List.generate(5, (i) => TextEditingController());

  bool _isGoogleSigningIn = false;
  bool _isFacebookSigningIn = false;

  @override
  void initState() {
    super.initState();

    ///per default the passwords are hidden
    _passwordVisible = false;
    _confirmPasswordVisible = false;
  }

  /// Builds the view.
  ///
  /// Uses a [Column] to display the logo and name of quiz app on top,
  /// and the text fields with the sign up button at the bottom. Contains also a
  /// [Row] with a line divider and a text in the middle, and a final [Row] with
  /// other available sign up options.
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      /// This avoids the overflow error.
      resizeToAvoidBottomInset: false,

      /// This [SingleChildScrollView] enables the user to scroll up/down when keyboard is open
      /// it contains a [Column] to display the logo and name of the app.
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 7,
                  child: Image.asset(
                    'lib/assets/images/logo_vertical.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              /// This [Column] displays the text fields and the sign up button,
              /// so the user can type their information and, if successful, create
              /// an account.
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Container(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                      ),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontSize: 30.0, fontWeight: FontWeight.bold),
                            ),
                          ),

                          /// Each [TextFormField] is used to get the user's
                          /// information and validate it
                          TextFormField(
                            ///if the user hasn't entered anything, validation fails
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email';
                              }
                              return null;
                            },
                            controller: textController[0],
                            decoration: const InputDecoration(
                                labelText: 'E-mail',
                                hintText: 'yourname@example.com'),
                          ),
                          TextFormField(
                            ///if the user hasn't entered anything, validation fails
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter username';
                              }
                              return null;
                            },
                            controller: textController[1],
                            decoration: const InputDecoration(
                              labelText: 'Username',
                            ),
                          ),
                          TextFormField(
                            ///hides/shows password based on user click
                            obscureText: !_passwordVisible,
                            controller: textController[2],

                            ///if the user hasn't entered anything, validation fails
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Password',

                              ///[IconButton] to click when user wants to see/hide password
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                          ),
                          TextFormField(
                            ///hides/shows password based on user click
                            obscureText: !_confirmPasswordVisible,
                            controller: textController[3],

                            ///if the user hasn't entered anything
                            ///or if passwords don't match, validation fails
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm password';
                              }
                              if (value != textController[2].text) {
                                return 'Not a match';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              hintText: 'Password',

                              ///[IconButton] to click when user wants to see/hide password
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _confirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _confirmPasswordVisible =
                                        !_confirmPasswordVisible;
                                  });
                                },
                              ),
                            ),
                          ),

                          /// This [Container] is contains [TextButton] to create a new account
                          /// to the user.
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Container(
                              height: size.height * 0.07,
                              alignment: Alignment.center,
                              width: size.width * 0.5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: TextButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    bool success = await controller.signUp(
                                        textController[0].text,
                                        textController[1].text,
                                        textController[2].text);
                                    if (success) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomeView()));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Login incorrect'),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              /// The [Row] widgets display line dividers and the
              /// [Expanded] one shows the 'or' text, so the user can
              /// also have a different sign up options, rather than typing
              /// their data manually.
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10.0, right: 14.0),
                      child: const Divider(
                          color: Colors.grey, height: 36, thickness: 1.0),
                    ),
                  ),
                  const Text("or sign up with",
                      style: TextStyle(fontSize: 16.0)),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 14.0, right: 10.0),
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
                  _isGoogleSigningIn
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary),
                        )
                      : IconButton(
                          icon: Image.asset('lib/assets/images/google.png'),
                          onPressed: () async {
                            setState(() {
                              _isGoogleSigningIn = true;
                            });
                            User? user = await controller.signInWithGoogle(
                                context: context);
                            setState(() {
                              _isGoogleSigningIn = false;
                            });
                            if (user != null) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => HomeView(),
                                ),
                              );
                            }
                          },
                        ),
                  _isFacebookSigningIn
                      ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary),
                  )
                  : IconButton(icon: Image.asset('lib/assets/images/facebook.png'),
                    onPressed: () async {
                      setState(() {
                        _isFacebookSigningIn = true;
                      });
                      User? user = await controller.signInWithFacebook(
                          context: context);
                      setState(() {
                        _isFacebookSigningIn = false;
                      });
                      if (user != null) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => HomeView(),
                          ),
                        );
                      }
                    },
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
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: ElevatedButton(
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
          ),
        ),
      ),
    );
  }
}
