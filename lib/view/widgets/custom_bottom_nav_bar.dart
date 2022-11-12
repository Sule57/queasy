import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:queasy/view/home_view.dart';
import 'package:queasy/view/leaderboard_view.dart';
import 'package:queasy/view/profile_view.dart';

import '../quiz_view.dart';

class CustomBottomNavBar extends StatefulWidget {
  final String pageTitle;

  const CustomBottomNavBar({Key? key, required this.pageTitle})
      : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  get pageTitle => widget.pageTitle;

  //TODO remove Quiz View from navBar when normal navigation is implemented
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: MotionTabBar(
        labels: const ['Home', 'Leaderboard', 'Profile', 'Quiz View'],
        icons: const [
          Icons.home_outlined,
          Icons.leaderboard_outlined,
          Icons.person_outline,
          Icons.question_mark,
        ],
        useSafeArea: true,

        // Initial selected tab should be based on the current page
        initialSelectedTab: pageTitle,
        tabIconColor: Colors.grey,
        tabSelectedColor: Theme.of(context).colorScheme.primary,
        onTabItemSelected: (int value) {
          goToAnotherPage(value);
        },
        textStyle: Theme.of(context).textTheme.caption,
      ),
    );
  }

  // This function is called when a tab is selected
  // It navigates to the page corresponding to the selected tab
  void goToAnotherPage(int value) {
    switch (value) {
      case 0:
        // Go to home view
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomeView(),
        ));
        break;
      case 1:
        // Go to leaderboard view
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const LeaderboardView(),
        ));
        break;
      case 2:
        // Go to profile view
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const UserProfile(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => QuizView(),
        ));
        break;
    }
  }
}
