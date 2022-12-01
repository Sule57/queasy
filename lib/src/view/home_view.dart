import 'package:flutter/material.dart';
import 'package:queasy/src/view/category_selection_view.dart';
import 'package:queasy/src/view/see_profile/profile_view.dart';
import 'package:queasy/src/view/quiz_selection_view.dart';
import 'package:queasy/src/view/play_quiz/quiz_view.dart';
import 'widgets/custom_bottom_nav_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///@param [textController] for getting user input
    final textController = TextEditingController();

    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(pageTitle: 'Home'),
      body: Center(
        child: Stack(children: [
          ///user profile at the top right corner
          Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                  icon: Container(
                    height: 66,
                    width: 66,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            "https://picsum.photos/500/300?random=1"),
                      ),
                    ),
                  ),

                  ///navigates to profile view when clicked
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ProfileView())))),
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                ///app logo
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
                  child: const Text("Public Tournaments"),

                  ///navigates to categories when clicked
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CategorySelectionView())),
                ),
                TextButton(
                  child: const Text("Join Quiz"),

                  ///opens a dialog for the user to enter a key to be able to enter a quiz
                  onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Enter key"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ///user input
                              TextField(
                                  controller: textController,
                                  decoration: const InputDecoration())
                            ],
                          ),
                          actions: [
                            ///cancel button
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel")),
                            TextButton(

                                ///join button navigates to a quiz if the entered key is confirmed
                                onPressed: () => {
                                      confirmKey(textController.text),
                                      if (confirmKey(textController.text))
                                        {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      QuizView()))
                                        }
                                      else
                                        {Navigator.pop(context)}
                                    },
                                child: const Text("Join"))
                          ],
                        );
                      }),
                ),
                TextButton(
                  child: const Text("My Quizzes"),

                  ///navigates to quiz selection view when clicked
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const QuizSelectionView())),
                ),
              ],
            ),
          )
        ]),
      ), //text with welcome message,
    );
  }

  ///confirms whether the entered key is valid (not yet implemented)
  bool confirmKey(String text) {
    return false;
  }
}
