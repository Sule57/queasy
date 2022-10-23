import 'package:flutter/material.dart';
import 'activities/home_screen.dart';
import 'activities/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => const LogInScreen(),
        '/home': (context) => const HomeScreen()
      },
    );
  }
}
