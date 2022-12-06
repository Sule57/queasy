import 'package:flutter/material.dart';
import 'package:queasy/src/view/home_view.dart';
import 'package:queasy/src/view/login/login_view.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../../services/auth.dart';
import '../login/login_desktop.dart';

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
          return MediaQuery.of(context).size.width < 700
              ? const HomeView()
              : const HomeView(); //later will be changed to desktop version
        } else {
          return MediaQuery.of(context).size.width < 700
              ? const LogInView()
              : const LogInDesktop();
        }
      },
    );
  }
}
