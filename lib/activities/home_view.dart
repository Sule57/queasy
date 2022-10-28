import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'Login Successful',
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          ),
        ),
      ), //text with welcome message,
    );
  }
}
