import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:queasy/src/model/profile.dart';
import 'package:queasy/src/model/statistics.dart';
import 'package:queasy/src/view/play_quiz/quiz_provider.dart';
import 'package:queasy/src/view/widgets/widget_tree.dart';
import 'package:queasy/utils/exceptions/user_already_exists.dart';

import 'constants/app_themes.dart';
import 'services/firebase_options.dart';
import 'src/view/see_leaderboard/leaderboard_provider.dart';

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
        ChangeNotifierProvider(create: (_) => LeaderboardProvider()),
      ],
      child: const Qeasy(),
    ));
  } catch (e) {
    print(e.toString());
  }
  Profile p = Profile(
      username: "newTestUser", email: 'test', hashPassword: 'fckhash??asf');
  try {} on UserAlreadyExistsException catch (e) {}
  //   Profile p = Profile(username: "statisticsTest", email: 'test', hashPassword: 'fckhash??asf');
  //   UserStatistics? s = await p.getUserStatistics();
  //   if(s!=null)
  //     print(s);
  //   else
  //     print("null");
  UserQuizzResult q1 = UserQuizzResult("quizz1", 50, 100, 300);
  UserQuizzResult q2 = UserQuizzResult("quizz2", 1, 100, 300);
  UserQuizzResult q3 = UserQuizzResult("quizz3", 50, 200, 300);
  UserQuizzResult q5 = UserQuizzResult("quizz5", 50, 200, 300);
  UserStatistics s = UserStatistics("statisticsTest", [q1, q2, q3, q5]);
  s.saveStatistics();
  print(s.toJson());
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
