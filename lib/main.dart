import 'package:flutter/material.dart';

import 'constants/app_themes.dart';
import 'constants/navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qeasy',
      theme: AppThemes().themeData,
      routes: Navigation(context).routes,
    );
  }
}
