import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const TextField(
              decoration: InputDecoration(
                  labelText: 'Email', hintText: 'yourname@example.com'),
            ),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Enter Password',
                hintText: 'Password',
              ),
            ),
            ElevatedButton(
              child: Text('LOGIN'),
              onPressed: () {
                // TODO use authentication to check if email and password are correct

                //test

                //This is code from Stanislav to test if Firebase is working
                // It may be useful

                // final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
                //
                // FutureBuilder(
                //   future: _fbApp,
                //   builder: (context, snapshot) {
                //     if (snapshot.hasError) {
                //       print("Error ${snapshot.error.toString()}");
                //       return Text("Something went wrong");
                //     } else if (snapshot.hasData) {
                //       return MyHomePage(title: "TestFirebasert");
                //     } else {
                //       return Center(
                //         child: CircularProgressIndicator(),
                //       );
                //     }
                //   },
                // );
                //
                // DatabaseReference _testRef =
                // FirebaseDatabase.instance.reference().child("test");
                // _testRef.set("Test ${Random().nextInt(100)}");

                // TODO navigate to HomeScreen if authentication is successful
              },
            ),
          ],
        ),
      ),
    ); //widgets for log in,
  }
}
