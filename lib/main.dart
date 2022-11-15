import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:queasy/firebase_options.dart';
import 'package:queasy/widget_tree.dart';

import 'constants/app_themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      name: 'queasy',
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  } catch (e) {
    print(e.toString());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WidgetTree(),
      debugShowCheckedModeBanner: false,
      title: 'Queasy',
      theme: AppThemes().themeData,
    );
  }
}
