/// ****************************************************************************
/// Created by Julia Agüero
/// Collaborators: Marin Sušić, Sophia Soares, Savo Simeunović, Anika Kraus,
/// Stanislav Dolapchiev, Nikol Kreshpaj, Gullu Gasimova, Endia Clark
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:queasy/constants/theme_provider.dart';
import 'package:queasy/src/view/see_questions/category_questions_provider.dart';
import 'package:queasy/src/view/login/login_provider.dart';
import 'package:queasy/src/view/play_quiz/play_quiz_provider.dart';
import 'package:queasy/src/view/my_quizzes/my_quizzes_provider.dart';
import 'package:queasy/src/view/statistics/statistics_provider.dart';
import 'package:queasy/src/view/widget_tree.dart';

import 'constants/app_themes.dart';
import 'services/firebase_options.dart';
import 'src/view/see_leaderboard/leaderboard_provider.dart';
import 'src/view/see_profile/profile_provider.dart';

final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      await Firebase.initializeApp(
        name: 'Queasy',
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PlayQuizProvider()),
          ChangeNotifierProvider(create: (_) => LeaderboardProvider()),
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
          ChangeNotifierProvider(create: (_) => CategoryQuestionsProvider()),
          ChangeNotifierProxyProvider<PlayQuizProvider, StatisticsProvider>(
            create: (BuildContext context) => StatisticsProvider(
                Provider.of<PlayQuizProvider>(context, listen: false)),
            update: (BuildContext context, PlayQuizProvider qp,
                    StatisticsProvider? sp) =>
                StatisticsProvider(qp),
          ),
          ChangeNotifierProvider(
              create: (_) => ThemeProvider(AppThemes().lightTheme)),
          ChangeNotifierProvider(create: (_) => LoginProvider()),
          ChangeNotifierProvider(create: (_) => CategoryQuestionsProvider()),
          ChangeNotifierProvider(create: (_) => SeeQuizzesProvider()),
        ],
        child: const Qeasy(),
      ),
    );
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
      theme: Provider.of<ThemeProvider>(context).currentTheme,
    );
  }
}
