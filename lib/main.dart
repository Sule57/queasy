import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:queasy/src/view/play_quiz/quiz_provider.dart';
import 'package:queasy/src/view/widgets/widget_tree.dart';

import 'constants/app_themes.dart';
import 'services/firebase_options.dart';

final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuizProvider()),
      ],
      child: const Qeasy(),
    ));
  } catch (e) {
    print(e.toString());
  }
}

class Qeasy extends StatelessWidget {
  const Qeasy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WidgetTree(),
      navigatorKey: navigator,
      debugShowCheckedModeBanner: false,
      title: 'Queasy',
      theme: AppThemes().themeData,
    );
  }
}
