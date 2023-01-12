/// ****************************************************************************
/// Created by Julia Agüero
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/src.dart';
import 'join_quiz_popup.dart';

/// Defines the navigation bar used in big screens.
///
/// It displays the navigation bar on the left side of the screen. It uses a
/// column to display the navigation bar items. The navigation bar items are
/// defined as ListTiles, with a leading icon and the title of the page.
///
/// The parameter [width] defines the width of the navigation bar.
//TODO make nav bar show what is the current page being displayed
class SideNavigation extends StatelessWidget {
  const SideNavigation({Key? key}) : super(key: key);
  static final double width = 300;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    TextStyle textStyle = Theme.of(context).textTheme.subtitle2!.copyWith(
          fontSize: 18,
          color: theme.colorScheme.onBackground,
        );

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        border: Border(
          right: BorderSide(
            color: theme.colorScheme.onBackground,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Image.asset(
                      "lib/assets/images/logo_horizontal.png",
                      height: 50,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home_outlined),
                  title: Text(
                    "Home",
                    style: textStyle,
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HomeView(),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.public),
                  title: Text(
                    "Public Tournaments",
                    style: textStyle,
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CategorySelectionView(),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.bar_chart),
                  title: Text(
                    "Leaderboard",
                    style: textStyle,
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LeaderboardView(),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.lock),
                  title: Text(
                    "Join Quiz",
                    style: textStyle,
                  ),
                  onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => JoinQuizPopup(),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.list),
                  title: Text(
                    "My categories",
                    style: textStyle,
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PrivateCategorySelectionView()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.fact_check_outlined),
                  title: Text(
                    "My quizzes",
                    style: textStyle,
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MyQuizzesView()));
                  },
                ),
              ],
            ),
            Column(
              children: [
                Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(
                    "Profile",
                    style: textStyle,
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileView(),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    "Logout",
                    style: textStyle.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  onTap: () async {
                    bool success = await ProfileViewController().signOut();
                    if (success) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginView(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Failed to sign out'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            width: 200,
                            shape: StadiumBorder()),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
