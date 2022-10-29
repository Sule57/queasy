import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:queasy/activities/widget_tree.dart';

import 'constants/app_themes.dart';
import 'constants/navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: const FirebaseOptions(
    apiKey: 'AIzaSyCNGjdJ0j86h8b_Bk7d9ts-hY4JZ7aNWcQ',
    appId: 'quizzapp-eb0f2',
    messagingSenderId: '1:17686953226:web:81a053f17c2b317edd0ef3',
    projectId: '17686953226',
  ),);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WidgetTree(),
      debugShowCheckedModeBanner: false,
      title: 'Qeasy',
      theme: AppThemes().themeData,
      //routes: Navigation(context).routes,
    );
  }
}
