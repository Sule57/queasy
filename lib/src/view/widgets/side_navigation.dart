import 'package:flutter/material.dart';
import 'package:queasy/src/view/category_selection_view.dart';
import 'package:queasy/src/view/home_view.dart';
import 'package:queasy/src/view/login/login_desktop.dart';
import 'package:queasy/src/view/see_leaderboard/leaderboard_view.dart';
import 'package:queasy/src/view/see_profile/profile_view.dart';
import 'package:queasy/src/view/see_profile/profile_view_controller.dart';

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
  final double width = 300;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle1!.copyWith(
          color: Colors.grey,
        );

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border(
          right: BorderSide(
            color: Colors.grey,
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
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                "lib/assets/images/logo_horizontal.png",
                height: 50,
              ),
            ),
            Column(
              children: [
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
                  onTap: () {
                    //TODO alert dialog to input key
                  },
                ),
                ListTile(
                  leading: Icon(Icons.list),
                  title: Text(
                    "My categories",
                    style: textStyle,
                  ),
                  onTap: () {
                    //TODO CategorySelectionView() but with user's categories
                  },
                ),
              ],
            ),
            Divider(
              color: Colors.grey,
              thickness: 0.5,
            ),
            Column(
              children: [
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
                  leading: Icon(Icons.info_outline),
                  title: Text(
                    "Support",
                    style: textStyle,
                  ),
                  onTap: () {
                    //TODO about
                  },
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
                  onTap: () {
                    bool success = ProfileViewController().signOut();
                    if (success) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LogInDesktop(),
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
