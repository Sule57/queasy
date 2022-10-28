import 'package:flutter/material.dart';

import 'package:queasy/activities/category_selection_view.dart';
import 'package:queasy/activities/home_view.dart';
import 'package:queasy/activities/leaderboard_view.dart';
import 'package:queasy/activities/login_view.dart';
import 'package:queasy/activities/profile_view.dart';
import 'package:queasy/activities/quiz_selection_view.dart';
import 'package:queasy/activities/quiz_view.dart';
import 'package:queasy/activities/register_view.dart';
import 'package:queasy/activities/statistics_view.dart';

class Navigation {
  BuildContext context;
  late Map<String, Widget Function(BuildContext)> routes;

  Navigation(this.context) {
    routes = {
      '/': (context) => const LogInView(),
      '/home': (context) => const HomeView(),
      '/register': (context) => const RegisterView(),
      '/profile': (context) => const ProfileView(),
      '/statistics': (context) => const StatisticsView(),
      '/play': (context) => const QuizView(),
      '/select-quiz': (context) => const QuizSelectionView(),
      '/select-category': (context) => const CategorySelectionView(),
      '/leaderboard': (context) => const LeaderboardView(),
    };
  }
}
