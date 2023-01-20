import 'package:flutter/material.dart';
import 'package:queasy/src/view/home_view.dart';
import 'package:queasy/src/view/login/login_view.dart';
import '../../services/auth.dart';

/// Widget tree for the app
class WidgetTree extends StatefulWidget {
  /// Constructor for the widget tree
  const WidgetTree({Key? key}) : super(key: key);

  /// Creates the state for the widget tree
  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

/// State for the widget tree
class _WidgetTreeState extends State<WidgetTree> {
  /// Builds the widget tree
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomeView();
        } else {
          return LoginView();
        }
      },
    );
  }
}
