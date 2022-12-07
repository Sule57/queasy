import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:queasy/constants/app_themes.dart';
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
          child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.height * .10,
              ),
              child: Column(
                children: [
                  /// App logo
                  Container(
                    padding: EdgeInsets.only(bottom: 13),
                    child: Image.asset(
                      height: MediaQuery.of(context).size.height * .60,
                      width: MediaQuery.of(context).size.width / 3,
                      'lib/assets/images/logo_vertical.png',
                    ),
                  ),

                  ///[Container] used for design
                  Container(
                    height: MediaQuery.of(context).size.height * .07,
                    width: MediaQuery.of(context).size.width / 2.5,
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20))),
                    child: TextButton(
                      child: const Text('Public Tournaments'),

                      /// Navigates to categories when clicked
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => CategorySelectionView())),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .07,
                    width: MediaQuery.of(context).size.width / 2.5,
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20))),
                    child: TextButton(
                      child: const Text('Join Quiz'),

                      /// Opens a dialog for the user to enter a key to be able to enter a quiz
                      onPressed: () => showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: purple,
                            title: Container(
                                alignment: Alignment.topCenter,
                                child: const Text('Enter key',
                                    style: TextStyle(color: Colors.white))),
                            content: Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  /// User input
                                  Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .07,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: TextField(
                                        controller: textController,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius:
                                                BorderRadius.circular(25.7),
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                            actions: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ///[ElevatedButton] to close the dialog if user wants to exit
                                    ElevatedButton(
                                      child: Text("Cancel",
                                          style: TextStyle(color: black)),

                                      ///if clicked clears all the text editing controllers
                                      onPressed: () => {
                                        Navigator.of(context).pop(),
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  orange),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                          ))),
                                    ),

                                    ///[ElevatedButton] to confirm the entered key
                                    ElevatedButton(
                                      child: Text("Join",
                                          style: TextStyle(color: black)),
                                      onPressed: () {
                                        if (textController.text.isNotEmpty) {
                                          ///confirmKey method is called from the controller
                                          ///result is saved in [success] variable
                                          bool success =
                                              confirmKey(textController.text);

                                          ///if successful the user is taken to the corresponding Quiz
                                          if (success) {
                                            // Navigator.of(context).push(
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             QuizView()))
                                          } else {
                                            Navigator.pop(context);
                                          }
                                        }
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  green),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                          ))),
                                    ),
                                  ]),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .07,
                    width: MediaQuery.of(context).size.width / 2.5,
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20))),
                    child: TextButton(
                      child: const Text('My Quizzes'),

                      /// Navigates to quiz selection view when clicked
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const QuizSelectionView())),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  /// Confirms whether the entered key is valid (not yet implemented)
  /// TODO
  bool confirmKey(String text) {
    return false;
  }
}
