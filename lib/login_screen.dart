import 'package:flutter/material.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children:
          <Widget> [
            TextField(
              decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'yourname@example.com'
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter Password',
                hintText: 'Password',
              ),
            ),
            ElevatedButton(
              child: Text('LOGIN'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    ); //widgets for log in,
  }
}

