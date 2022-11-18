import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:queasy/view/home_view.dart';
import 'package:queasy/view/leaderboard_view.dart';
import 'package:queasy/view/profile_view.dart';

import '../quiz_view.dart';

/// This is the custom bottom navigation bar.
///
/// It is the navigation bar that the user sees at the bottom of the screen in
/// every view. It shows three icons, one for each view, and when pressed, it
/// navigates to the corresponding view. It uses colors from [AppThemes].
class CustomBottomNavBar extends StatefulWidget {
  /// This is the title of the page that the user is currently on.
  final String pageTitle;

  const CustomBottomNavBar({Key? key, required this.pageTitle})
      : super(key: key);

  /// Creates a [CustomBottomNavBar] state.
  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  get pageTitle => widget.pageTitle;

  //TODO remove Quiz View from navBar when normal navigation is implemented
  // TODO add controller
  // TODO dont create a new view every time, fix nav bar and "scroll" views

  /// This builds the bottom navigation bar.
  ///
  /// It uses a [MotionTabBarView] to display the icons and navigate to the
  /// corresponding view. It uses a [MotionTabController] to control the
  /// navigation.
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
        /// The views used are fixed.
        labels: const ['Home', 'Leaderboard', 'Profile', 'Quiz View'],
        icons: const [
          Icons.home_outlined,
          Icons.leaderboard_outlined,
          Icons.person_outline,
          Icons.question_mark,
        ],
        useSafeArea: true,

        /// Initial selected tab should be based on the current page. Uses
        /// [pageTitle] to determine which tab should be selected.
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

  /// This function is called when a tab is selected.
  /// It navigates to the page corresponding to the selected tab.
  /// [value] is the index of the selected tab.
  void goToAnotherPage(int value) {
    switch (value) {
      case 0:
        /// This takes the user to the [HomeView].
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomeView(),
        ));
        break;
      case 1:
        /// This takes the user to the [LeaderboardView].
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const LeaderboardView(),
        ));
        break;
      case 2:
        /// This takes the user to the [ProfileView].
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UserProfile(),
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
