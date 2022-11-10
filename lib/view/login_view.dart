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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
            ElevatedButton(
              child: Text('LOGIN'),
              onPressed: signInWithEmailAndPassword,
            ),
          ],
        ),
      ),
    ); //widgets for log in,
  }
}
