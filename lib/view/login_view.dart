import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth.dart';

class LogInView extends StatefulWidget {
  const LogInView({Key? key}) : super(key: key);

  @override
  State<LogInView> createState() => _LogInViewState();
}

class _LogInViewState extends State<LogInView> {
  String? errorMessage = '';

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
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
          children:[
            Padding(
              padding: const EdgeInsets.only(top: 1.0, bottom: 7.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 5,
                child: Image.asset(
                  'lib/assets/images/logo_and_name.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right:8.0),
                  child:Container(
                    padding: const EdgeInsets.only(left: 15.0, right:15.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      const BorderRadius.all(Radius.circular(16.0)),
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
                          decoration: InputDecoration(
                              labelText: 'Email', hintText: 'yourname@example.com'),
                        ),
                        TextField(
                          controller: _controllerPassword,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Enter Password',
                            hintText: 'Password',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:10, bottom: 10),
                          child: RoundedButton(
                            buttonName: 'Log In',
                            backgroundColor:Theme.of(context).colorScheme.primary,
                            textColor: Theme.of(context).colorScheme.background,
                            /*onPressed: signInWithEmailAndPassword,*/
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
                const Text("or sign up with", style: TextStyle(fontSize: 16.0)),
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
          ],
        ),
      ),
    );
  }
}
