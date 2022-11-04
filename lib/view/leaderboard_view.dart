import 'package:flutter/material.dart';
import 'custom_bottom_nav_bar.dart';

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: CustomBottomNavBar(pageTitle: 'Leaderboard'),
      body: Center(
        child: Text('Leaderboard View'),
      ),
    );
  }
}
