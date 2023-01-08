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
import 'package:provider/provider.dart';
import 'package:queasy/src/view/play_quiz/quiz_view.dart';
import 'package:queasy/src/view/see_leaderboard/leaderboard_view.dart';
import 'package:queasy/src/view/category_selection_view.dart';
import 'package:queasy/src/view/see_profile/profile_view.dart';
import 'package:queasy/src/view/private_category_selection_view.dart';
import 'package:queasy/src/view/widgets/side_navigation.dart';

import '../../src.dart';
import 'see_profile/profile_provider.dart';

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
    double height = MediaQuery.of(context).size.height;

    return width > 700
        ? Scaffold(
            body: Center(
                child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                      child: Align(
                    alignment: FractionalOffset.topRight,
                    child: Container(
                      width: width / 3.5,
                      height: height / 4,
                      //alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                        color: const Color(0xff9fc490),
                      ),
                    ),
                  ))
                ],
              ),
              Column(
                children: [
                  Expanded(
                      child: Align(
                    alignment: FractionalOffset.topRight,
                    child: Container(
                      margin: const EdgeInsets.only(top: 130),
                      width: width / 9,
                      height: height / 2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                        ),
                        color: const Color(0xffF19C79),
                      ),
                    ),
                  ))
                ],
              ),
              Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomRight,
                      child: Container(
                        width: width / 1.7,
                        height: height / 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: const Color(0xfff1ffe7),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.center,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 200, top: 50),
                        child: Container(
                          width: width / 2.5,
                          height: height / 1.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: RichText(
                              text: TextSpan(
                                text: 'Text your knowledge..',
                                style: const TextStyle(
                                    color: const Color(0xffF1FFE7),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SideNavigation(),
              SizedBox(
                width: width - SideNavigation().width,
              ),
            ],
          )))
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

  ///@param [textController] for getting user input
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Provider.of<ProfileProvider>(context).setProfile();
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
                              height: MediaQuery.of(context).size.height * .07,
                              width: MediaQuery.of(context).size.width / 2,
                              child: TextField(
                                controller: textController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(25.7),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                    actions: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ///[ElevatedButton] to close the dialog if user wants to exit
                            ElevatedButton(
                              child:
                                  Text("Cancel", style: TextStyle(color: dark)),

                              ///if clicked clears all the text editing controllers
                              onPressed: () => {
                                Navigator.of(context).pop(),
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(orange),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))),
                            ),

                            ///[ElevatedButton] to confirm the entered key
                            ElevatedButton(
                              child:
                                  Text("Join", style: TextStyle(color: dark)),
                              onPressed: () async {
                                if (textController.text.isNotEmpty) {
                                  // /confirmKey method is called from the controller
                                  // /result is saved in [success] variable
                                  bool success =
                                  await Quiz.checkIfQuizExists(id: textController.text);

                                  if (success) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => QuizView(
                                          id: textController.text,
                                        ),
                                      ),
                                    );
                                  } else {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                      content: Text(
                                        'Invalid key',
                                        textAlign: TextAlign.center,
                                        ),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(green),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))),
                            ),
                          ]),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: 5,
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PrivateCategorySelectionView())),
              child: Text(
                'My Quizzes',
                style: TextStyle(
                  color: purple,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(light),
              ),
            )
          ],
        ),
        //       )
        //     ],
        //   ),
      ),
    );
  }

  /// Confirms whether the entered key is valid (not yet implemented)
  bool confirmKey(String text) {
    /// TODO: implement a communication with Firebase that checks if the key exists
    return false;
  }
}
