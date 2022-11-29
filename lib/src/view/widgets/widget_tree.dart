import 'package:flutter/material.dart';
import 'package:queasy/src/view/home_view.dart';
import 'package:queasy/src/view/login_view.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../services/auth.dart';
import '../desktop/login-desktop.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (kIsWeb) {
            return const HomeView();
          } else {
            return const HomeView();
          }
        } else {
          if (kIsWeb) {
            return const LogInDesktop();
          } else {
            return const LogInView();
          }
        }
      },
    );
  }
}
