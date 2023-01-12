/// ****************************************************************************
/// Created by Gullu Gasimova
/// Collaborators: Sophia Soares, Julia Agüero
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:queasy/constants/app_themes.dart';
import 'package:queasy/src/view/see_leaderboard/leaderboard_view.dart';
import 'package:queasy/src/view/category_selection_view.dart';
import 'package:queasy/src/view/see_profile/profile_view.dart';
import 'package:queasy/src/view/private_category_selection_view.dart';
import 'package:queasy/src/view/widgets/join_quiz_popup.dart';
import 'package:queasy/src/view/widgets/side_navigation.dart';

import '../../src.dart';

/// This is the base view for navigation. It contains the bottom navigation bar
/// and the [pages] that are navigated to when the bottom navigation bar is tapped.
class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  /// The index of the currently selected page.
  late int selectedPage;

  /// The list of pages that the user can navigate to.
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    selectedPage = 0;
    pages = [
      HomeWidgets(),

      /// This avoids other pages to be built unnecessarily.
      const SizedBox(),
      const SizedBox(),
    ];
  }

  /// This shows the custom bottom navigation bar, which is a [MotionTabBar], from
  /// the [motion_tab_bar_v2] package. It shows three icons, one for each displayed view, and when pressed,
  /// it navigates to the corresponding view. It uses the [selectedPage] to determine
  /// which tab is selected and [pages] list to determine which view to display.
  ///
  /// The [IndexedStack] widget is used to display only one of its children (screens) at a time.
  /// The index of the screen to be displayed is specified by the [index] property.
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return width > 700
        ? Scaffold(
            body: Row(
            children: [
              SideNavigation(),
              SizedBox(
                width: width - SideNavigation.width,
                child: HomeWidgets(),
              ),
            ],
          ))
        : Scaffold(
            bottomNavigationBar: MotionTabBar(
              labels: const ['Home', 'Leaderboard', 'Profile'],
              initialSelectedTab: 'Home',
              icons: const [
                Icons.home_outlined,
                Icons.leaderboard_outlined,
                Icons.person_outline,
              ],
              useSafeArea: true,
              tabIconColor: Colors.grey,
              tabSelectedColor: Theme.of(context).colorScheme.primary,
              tabBarColor: Theme.of(context).colorScheme.background,
              textStyle: Theme.of(context).textTheme.caption,
              onTabItemSelected: (index) {
                /// This method checks if the chosen page has already been built.
                /// If it hasn't, then it still is a SizedBox and won't be rebuilt.
                setState(() {
                  if (pages[index] is SizedBox) {
                    if (index == 1) {
                      pages[index] = const LeaderboardView();
                    } else if (index == 2) {
                      pages[index] = ProfileView();
                    }
                  }
                  selectedPage = index;
                });
              },
            ),
            body: IndexedStack(
              index: selectedPage,
              children: pages,
            ),
          );
  }
}

/// This is the home view. It is the first view that the user sees when they are logged in.
/// It shows the logo, the name of the app, and then 3 options for the user to choose from.
/// The user can choose to play in a public tournament, to join a private quiz or to see their
/// own quizzes status.
class HomeWidgets extends StatelessWidget {
  HomeWidgets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            /// App logo
            Container(
              padding: EdgeInsets.all(13),
              child: Image.asset(
                height: MediaQuery.of(context).size.height * .40,
                width: double.infinity,
                'lib/assets/images/logo_vertical.png',
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CategorySelectionView())),
              child: Text(
                'Public Tournaments',
                style: TextStyle(
                  color: purple,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(light),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(light),
              ),
              child: Text(
                'Join Quiz',
                style: TextStyle(
                  color: purple,
                ),
              ),
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => JoinQuizPopup(),
              ),
            ),
            SizedBox(height: 5),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PrivateCategorySelectionView())),
              child: Text(
                'My Categories',
                style: TextStyle(
                  color: purple,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(light),
              ),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => MyQuizzesView())),
              child: Text(
                'My quizzes',
                style: TextStyle(
                  color: purple,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(light),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
