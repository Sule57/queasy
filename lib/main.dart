

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:queasy/widget_tree.dart';

import 'constants/app_themes.dart';
import 'constants/navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        // this configuration must remain the same
          apiKey: "AIzaSyCNGjdJ0j86h8b_Bk7d9ts-hY4JZ7aNWcQ",
          authDomain: "quizzapp-eb0f2.firebaseapp.com",
          databaseURL: "https://quizzapp-eb0f2-default-rtdb.europe-west1.firebasedatabase.app",
          projectId: "quizzapp-eb0f2",
          storageBucket: "quizzapp-eb0f2.appspot.com",
          messagingSenderId: "17686953226",
          appId: "1:17686953226:web:81a053f17c2b317edd0ef3",
          measurementId: "G-MSF5DXS9QN"
      ),
    );
    runApp(MyApp());
  } catch (e) {
    print(e.toString());
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCNGjdJ0j86h8b_Bk7d9ts-hY4JZ7aNWcQ",
          authDomain: "quizzapp-eb0f2.firebaseapp.com",
          databaseURL:
          "https://quizzapp-eb0f2-default-rtdb.europe-west1.firebasedatabase.app",
          projectId: "quizzapp-eb0f2",
          storageBucket: "quizzapp-eb0f2.appspot.com",
          messagingSenderId: "17686953226",
          appId: "1:17686953226:web:81a053f17c2b317edd0ef3",
          measurementId: "G-MSF5DXS9QN"
      ),
      name: 'qeasy_web_app',
    );
    runApp(MyApp());
  }
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
