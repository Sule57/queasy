import 'package:flutter/material.dart';

import 'package:queasy/view/category_selection_view.dart';
import 'package:queasy/view/home_view.dart';
import 'package:queasy/view/leaderboard_view.dart';
import 'package:queasy/view/login_view.dart';
import 'package:queasy/view/profile_view.dart';
import 'package:queasy/view/quiz_selection_view.dart';
import 'package:queasy/view/quiz_view.dart';
import 'package:queasy/view/register_view.dart';
import 'package:queasy/view/statistics_view.dart';

class Navigation {
  BuildContext context;
  late Map<String, Widget Function(BuildContext)> routes;

  Navigation(this.context) {
    routes = {
      '/': (context) => const LogInView(),
      '/home': (context) => const HomeView(),
      '/register': (context) => const RegisterView(),
      '/profile': (context) => const UserProfile(),
      '/statistics': (context) => const StatisticsView(),
      '/play': (context) => QuizView(),
      '/select-quiz': (context) => const QuizSelectionView(),
      '/select-category': (context) => const CategorySelectionView(),
      '/leaderboard': (context) => const LeaderboardView(),
    };
  }
}
