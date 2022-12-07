import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:queasy/src/view/see_leaderboard/leaderboard_view.dart';
import 'package:queasy/src/view/category_selection_view.dart';
import 'package:queasy/src/view/see_profile/profile_view.dart';
import 'package:queasy/src/view/quiz_selection_view.dart';

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
    return Scaffold(
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

  ///@param [textController] for getting user input
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  /// App logo
                  Padding(
                    padding: const EdgeInsets.only(top: 1.0, bottom: 7.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 5,
                      child: Image.asset(
                        'lib/assets/images/logo_vertical.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  TextButton(
                    child: const Text('Public Tournaments'),

                    /// Navigates to categories when clicked
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => CategorySelectionView())),
                  ),
                  TextButton(
                    child: const Text('Join Quiz'),

                    /// Opens a dialog for the user to enter a key to be able to enter a quiz
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Enter key'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /// User input
                              TextField(
                                  controller: textController,
                                  decoration: const InputDecoration())
                            ],
                          ),
                          actions: [
                            /// Cancel button
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel')),
                            TextButton(

                                /// Join button navigates to a quiz if the entered key is confirmed
                                onPressed: () => {
                                      confirmKey(textController.text),
                                      if (confirmKey(textController.text))
                                        {
                                          // Navigator.of(context).push(
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             QuizView()))
                                        }
                                      else
                                        {
                                          Navigator.pop(context),
                                        }
                                    },
                                child: const Text('Join')),
                          ],
                        );
                      },
                    ),
                  ),
                  TextButton(
                    child: const Text('My Quizzes'),

                    /// Navigates to quiz selection view when clicked
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const QuizSelectionView())),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Confirms whether the entered key is valid (not yet implemented)
  /// TODO
  bool confirmKey(String text) {
    return false;
  }
}
