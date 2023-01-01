import 'package:flutter/material.dart';
import '../../../constants/app_themes.dart';
import '../category_selection_view.dart';
import '../home_view.dart';
import '../login/login_desktop.dart';
import '../see_leaderboard/leaderboard_view.dart';
import '../see_profile/profile_view.dart';
import '../see_profile/profile_view_controller.dart';

class DesktopNavigation extends StatelessWidget {
  ///[textController] for getting user input.
  final textController = TextEditingController();

  ///[ProfileViewController] for calling sign out upon user request.
  late ProfileViewController controller;

  bool success = true;

  DesktopNavigation({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 320,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              SafeArea(
                child: Image.asset(
                  "lib/assets/images/logo_horizontal.png",
                  height: 50,
                ),
              ),
            ]),
          ),
          Divider(
            height: 20,
            color: Colors.transparent,
          ),
          MouseRegion(
              cursor: SystemMouseCursors.click,

              ///[Gesture Detector] used to redirect to Home Page
              child: GestureDetector(
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => HomeView())),
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20, bottom: 7),
                  child: Text(
                    "Home",
                    style: TextStyle(color: Colors.grey, fontSize: 30),
                  ),
                ),
              )),
          Divider(
            height: 20,
            color: Colors.transparent,
          ),

          ///[Gesture Detector] used to redirect to Category Page
          MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CategorySelectionView())),
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20, bottom: 7),
                  child: Text(
                    "Public Tournaments",
                    style: TextStyle(color: Colors.grey, fontSize: 30),
                  ),
                ),
              )),
          Divider(
            height: 20,
            color: Colors.transparent,
          ),

          ///[Gesture Detector] used to Join Quiz. Opens a dialog for the user to enter a key to be able to enter a quiz.
          MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => showDialog(
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
                                    MediaQuery.of(context).size.height * .07,
                                width: MediaQuery.of(context).size.width / 2,
                                child: TextField(
                                  controller: textController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
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
                                child: Text("Cancel",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary)),

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
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                              ),

                              ///[ElevatedButton] to confirm the entered key
                              ElevatedButton(
                                child: Text("Join",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary)),
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
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20, bottom: 7),
                  child: Text(
                    "Join Quiz",
                    style: TextStyle(color: Colors.grey, fontSize: 30),
                  ),
                ),
              )),
          Divider(
            height: 20,
            color: Colors.transparent,
          ),

          ///[Gesture Detector] used to redirect to Leaderboard Page
          MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LeaderboardView())),
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20, bottom: 7),
                  child: Text(
                    "Leaderboard",
                    style: TextStyle(color: Colors.grey, fontSize: 30),
                  ),
                ),
              )),
          Divider(
            height: 20,
            color: Colors.transparent,
          ),

          ///[Gesture Detector] used to redirect to Profile Page.
          MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfileView())),
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20, bottom: 7),
                  child: Text(
                    "Profile",
                    style: TextStyle(color: Colors.grey, fontSize: 30),
                  ),
                ),
              )),
          Divider(
            height: 20,
            color: Colors.transparent,
          ),

          ///[Gesture Detector] used sign out of app.
          MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => {
                  success = controller.signOut(),
                  if (success)
                    {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LogInDesktop()))
                    }
                  else
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Failed to sign out'),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            width: 200,
                            shape: StadiumBorder()),
                      )
                    }
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20, bottom: 7),
                  child: Text(
                    "Sign Out",
                    style: TextStyle(color: orange, fontSize: 30),
                  ),
                ),
              )),
        ]));
  }

  /// Confirms whether the entered key is valid (not yet implemented)
  /// TODO
  bool confirmKey(String text) {
    return false;
  }
}
