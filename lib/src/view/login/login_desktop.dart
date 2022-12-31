import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:queasy/constants/app_themes.dart';
import 'package:queasy/services/auth.dart';
import 'package:queasy/src/view/home_view.dart';
import 'package:queasy/src/view/registration/register_view.dart';

/// This is the login view for web browser.
///
/// It is the view that the user sees when they are trying to sign in to
/// use the app. It shows two fields for the user to fill in, and a button
/// to sign up. When the login is over, the user is taken to [HomeView].
class LogInDesktop extends StatefulWidget {
  const LogInDesktop({Key? key}) : super(key: key);

  @override
  State<LogInDesktop> createState() => _LogInDesktopState();
}

class _LogInDesktopState extends State<LogInDesktop> {
  ///[errorMessage] to print to the console if login fails
  String? errorMessage = '';

  ///[formKey] for login Form
  final formKey = GlobalKey<FormState>();

  ///[formKeyForgotPassword] for login Form
  final formKeyForgotPassword = GlobalKey<FormState>();

  ///[controllerEmail] and [controllerPassword] are text controllers to take user input
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  TextEditingController emailForgotPassword = new TextEditingController();

  ///[errorForgotPassword] is to display error message when email entered in delete account container is not entered
  bool errorForgotPassword = false;

  ///[passwordVisible] is for hiding/showing the password
  bool passwordVisible = false;

  ///[signInWithEmailAndPassword] method calls signInWithEmailAndPassword from Auth.dart
  ///if returns true -> login successful
  ///if returns false -> login failed and errorMessage will be displayed
  Future<bool> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: controllerEmail.text,
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

    ///password is hidden as default
    passwordVisible = false;
  }

  /// Builds the view.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// This avoids the overflow error.
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          ///[Container] to display white rectangle in the top right corner
          Container(
              alignment: Alignment.topRight,
              child: Container(
                  height: MediaQuery.of(context).size.height * .25,
                  width: MediaQuery.of(context).size.width / 5.5,
                  decoration: BoxDecoration(
                      color: light,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                      )))),

          ///[SingleChildScrollView] is to avoid bottom overflow when window size is made smaller
          SingleChildScrollView(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 1.8,
                right: MediaQuery.of(context).size.width / 10,
                top: MediaQuery.of(context).size.height * .10,
                bottom: MediaQuery.of(context).size.height * .10),

            ///[Form] login form
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
                        "Log In",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * .10,
                        ),
                      ),
                    ),

                    ///[Text] to display error message to the user
                    Text(
                      errorMessage == '' ? '' : 'Humm? $errorMessage',
                      style: TextStyle(color: purple),
                    ),

                    ///[TextFormField] is for user to enter email
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
                      onFieldSubmitted: (value) {
                        if (formKey.currentState!.validate()) {
                          signInWithEmailAndPassword();
                        }
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * .05),

                      ///[TextFormField] is for user to enter password
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
                        onFieldSubmitted: (value) {
                          if (formKey.currentState!.validate()) {
                            signInWithEmailAndPassword();
                          }
                        },
                      ),
                    ),

                    ///[TextButton] for if the user has forgotten their password
                    TextButton(
                        onPressed: () => {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(builder:
                                        (context, StateSetter setState) {
                                      if (MediaQuery.of(context).size.width <
                                          700) {
                                        Navigator.of(context).pop();
                                      }
                                      return AlertDialog(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        scrollable: true,
                                        title: Container(
                                          alignment: Alignment.topCenter,
                                          child: Text(
                                            "Reset password",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        actions: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                child: Text("Cancel",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onBackground)),
                                                onPressed: () => {
                                                  Navigator.of(context).pop()
                                                },
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary),
                                                    shape: MaterialStateProperty
                                                        .all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18.0),
                                                    ))),
                                              ),
                                              ElevatedButton(
                                                child: Text("Confirm",
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onBackground)),
                                                onPressed: () {
                                                  if (formKeyForgotPassword
                                                      .currentState!
                                                      .validate()) {}
                                                },
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all<Color>(
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .tertiary),
                                                    shape: MaterialStateProperty
                                                        .all<RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18.0),
                                                    ))),
                                              ),
                                            ],
                                          ),
                                        ],
                                        content: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .10,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                5,
                                            child: Form(
                                              key: formKeyForgotPassword,
                                              child: Stack(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Text("Email",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                      SizedBox(width: 25),
                                                      Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            .05,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            6,
                                                        child: TextFormField(
                                                          ///if the user hasn't entered anything, validation fails
                                                          validator: (value) {
                                                            setState(() {
                                                              errorForgotPassword =
                                                                  false;
                                                            });
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              setState(() {
                                                                errorForgotPassword =
                                                                    true;
                                                              });
                                                              return null;
                                                            }
                                                            return null;
                                                          },
                                                          controller:
                                                              emailForgotPassword,
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                                    bottom: 15,
                                                                    left: 20),
                                                            filled: true,
                                                            fillColor:
                                                                Colors.white,
                                                            border:
                                                                UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25.7),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  errorForgotPassword
                                                      ? Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 30,
                                                                  left: 90),
                                                          child: Container(
                                                              //width: MediaQuery.of(context).size.width / 4,
                                                              child: Text(
                                                            "Please enter email",
                                                            style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .onTertiary,
                                                            ),
                                                          )),
                                                        )
                                                      : Container()
                                                ],
                                              ),
                                            )),
                                      );
                                    });
                                  })
                            },
                        child: const Text("Forgot Password?")),

                    Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .02,
                          left: MediaQuery.of(context).size.width / 13),
                      width: MediaQuery.of(context).size.width / 4,

                      ///[ElevatedButton] for user to log in
                      child: ElevatedButton(
                        onPressed: (() async {
                          ///if form validation returns true, user is signed in
                          if (formKey.currentState!.validate()) {
                            bool success = await signInWithEmailAndPassword();

                            ///if signInWithEmailAndPassword is successful, user is taken to [HomeView]
                            if (success) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const HomeView()));
                            } else {
                              ///if signInWithEmailAndPassword is not successful, then error message is printed
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
                          "Log in",
                          style: TextStyle(fontSize: 23),
                        ),
                      ),
                    ),

                    ///[Row] which contains [Divider] is to separate form from social media sign in buttons
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
                    /// This [Row] displays the social media sign in buttons.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ///Google
                        IconButton(
                          icon: Image.asset('lib/assets/images/google.png'),
                          onPressed: () {},
                        ),

                        ///Facebook
                        IconButton(
                          icon: Image.asset(
                            'lib/assets/images/facebook.png',
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "New User? ",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: ElevatedButton(
                            child: Text(
                              'Register',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
                            onPressed: () => {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RegisterView()))
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                )),
          ),

          ///[Container] to display orange box at top left for design
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

          ///[Container] to display green box at bottom left for design
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

          ///[Container] to display white box in center left for design
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

          ///[Container] to display app logo and name
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
