import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:queasy/src/view/registration/register_view.dart';
import 'package:queasy/src/view/widgets/rounded-button.dart';
import '../../../services/auth.dart';
import '../home_view.dart';

/// This is the mobile version of the login view.
///
/// It is the view that the user sees when they are trying to sign in to
/// use the app. It shows two fields for the user to fill in, and a button
/// to sign up. When the login is over, the user is taken to [HomeView].
class LogInView extends StatefulWidget {
  const LogInView({Key? key}) : super(key: key);

  @override
  State<LogInView> createState() => _LogInViewState();
}

class _LogInViewState extends State<LogInView> {
  String? errorMessage = '';

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  TextEditingController emailForgotPassword = new TextEditingController();

  ///[errorForgotPassword] is to display error message when email entered in delete account container is not entered
  bool errorForgotPassword = false;

  ///[formKey] used for Form in EditProfile button
  final formKey = GlobalKey<FormState>();

  Future<bool> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 1.0, bottom: 7.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 5,
                child: Image.asset(
                  'lib/assets/images/logo_vertical.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Container(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            'Log In',
                            style: TextStyle(
                                fontSize: 30.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(errorMessage == '' ? '' : 'Humm? $errorMessage'),
                        TextField(
                          controller: _controllerEmail,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'yourname@example.com'),
                          onSubmitted: (value) async {
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
                          },
                        ),
                        TextField(
                          controller: _controllerPassword,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: 'Enter Password',
                            hintText: 'Password',
                          ),
                          onSubmitted: (value) async {
                            bool success = await signInWithEmailAndPassword();

                            ///if signInWithEmailAndPassword is successful, user is taken to [HomeView]
                            if (success) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const HomeView()));
                            } else {
                              ///if signInWithEmailAndPassword is not successful, then error message is printed
                              print(errorMessage);
                            }
                          },
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          //padding: EdgeInsets.all(),
                          child: TextButton(
                            child: const Text("Forgot Password?"),
                            onPressed: () => {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(builder:
                                        (context, StateSetter setState) {
                                      if (MediaQuery.of(context).size.width >
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
                                                  if (formKey.currentState!
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
                                                2,
                                            child: Form(
                                              key: formKey,
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
                                                            3,
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
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: RoundedButton(
                            buttonName: 'Log In',
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            textColor: Theme.of(context).colorScheme.background,
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                bool success =
                                    await signInWithEmailAndPassword();

                                ///if signInWithEmailAndPassword is successful, user is taken to [HomeView]
                                if (success) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const HomeView()));
                                } else {
                                  ///if signInWithEmailAndPassword is not successful, then error message is printed
                                  print(errorMessage);
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 14.0),
                    child: const Divider(
                        color: Colors.grey, height: 36, thickness: 1.0),
                  ),
                ),
                const Text(
                  "or log in with",
                  style: TextStyle(fontSize: 16.0),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 14.0, right: 10.0),
                    child: const Divider(
                        color: Colors.grey, height: 36, thickness: 1.0),
                  ),
                ),
              ],
            ),
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
                IconButton(
                  icon: Image.asset(
                    'lib/assets/images/twitter.png',
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
        ),
      ),
    );
  }
}
