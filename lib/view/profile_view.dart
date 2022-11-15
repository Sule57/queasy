import 'package:flutter/material.dart';
import 'package:queasy/constants/app_themes.dart';
import '../controller/profile-view-controller.dart';
import 'widgets/custom_bottom_nav_bar.dart';

class UserProfile extends StatefulWidget {
  final ProfileViewController controller = ProfileViewController();

  UserProfile({Key? key}) : super(key: key);

  ///creates ProfileView class
  @override
  State<UserProfile> createState() => ProfileView();
}

class ProfileView extends State<UserProfile> {
  get controller => widget.controller;

  final List<TextEditingController> textController =
      List.generate(8, (i) => TextEditingController());

  @override
  void dispose() {
    /// Cleans up the controllers when the widget is disposed.
    for (var element in textController) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(pageTitle: 'Profile'),
      body: Center(
        child: Stack(children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //TO-DO
                ///profile picture of the user
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () => {controller.editProfilePic(" ")},
                ),

                ///username
                TextButton(
                  child: Text(controller.player.username),

                  ///opens the dialog when clicked
                  onPressed: () => showAlertDialog(
                      context,
                      "username",
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          //position
                          mainAxisSize: MainAxisSize.min,
                          // wrap content in flutter
                          children: <Widget>[
                            ///to enter the new username
                            TextField(
                              controller: textController[0],
                              decoration: const InputDecoration(
                                labelText: 'Enter New Username',
                              ),
                            ),
                          ]),
                      controller.editUsername(textController[0].text)),
                ),

                ///first name and last name of the user
                TextButton(
                  child: Text(controller.player.firstName +
                      " " +
                      controller.player.lastName),

                  ///opens the dialog when clicked
                  onPressed: () => showAlertDialog(
                      context,
                      "name",
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ///to enter the new firstname
                            TextField(
                              controller: textController[1],
                              decoration: const InputDecoration(
                                labelText: 'Enter New Firstname',
                              ),
                            ),

                            ///to enter the new lastname
                            TextField(
                              controller: textController[2],
                              decoration: const InputDecoration(
                                labelText: 'Enter New Lastname',
                              ),
                            ),
                          ]),
                      controller.editName(
                          textController[1].text, textController[2].text)),
                ),

                ///email of the user
                TextButton(
                  child: Text(controller.player.email),

                  ///opens the dialog when clicked
                  onPressed: () => showAlertDialog(
                      context,
                      "email",
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ///to ener the new email
                            TextField(
                              controller: textController[3],
                              decoration: const InputDecoration(
                                labelText: 'Enter New Email',
                                hintText: 'yourname@example.com',
                              ),
                            ),
                          ]),
                      controller.editEmail(textController[3].text)),
                ),
              ]),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ///displays the bio of the user
                Container(
                  height: 150.0,
                  width: 300.0,
                  padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
                  color: green,
                  child: Column(children: [
                    TextButton(
                      child: const Text("Bio"),

                      ///opens the dialog when clicked
                      onPressed: () => showAlertDialog(
                          context,
                          "email",
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ///to ener the new email
                                TextField(
                                  controller: textController[4],
                                  decoration: const InputDecoration(
                                    labelText: 'Enter New Bio',
                                  ),
                                ),
                              ]),
                          controller.editEmail(textController[4].text)),
                    ),
                    Text(controller.player.bio),
                  ]),
                ),

                ///shows statistics when clicked
                const ExpansionTile(
                  title: Text('View Personal Statistics'),
                  children: <Widget>[
                    StatsContainer(true),
                  ],
                ),

                ///button to change password
                ElevatedButton(
                  child: const Text("Change Password"),

                  ///opens the dialog when clicked
                  onPressed: () => showAlertDialog(
                      context,
                      "password",
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ///to enter the old password
                          TextField(
                            controller: textController[5],
                            decoration: const InputDecoration(
                              labelText: 'Enter Password',
                            ),
                          ),

                          ///to enter the new password
                          TextField(
                            controller: textController[6],
                            decoration: const InputDecoration(
                              labelText: 'Enter New Password',
                            ),
                          ),

                          ///to confirm the new password
                          TextField(
                            controller: textController[7],
                            decoration: const InputDecoration(
                              labelText: 'Confirm New Password',
                            ),
                          ),
                        ],
                      ),
                      controller.editPassword(textController[5].text,
                          textController[6].text, textController[7].text)),
                ),
              ]),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ///button to sign out
              ElevatedButton(
                child: const Text("Sign out"),
                onPressed: () => controller.signOut,
              ),

              ///button to delete the account
              TextButton(
                child: const Text("Delete Account"),
                onPressed: () => controller.deleteAccount,
              )
            ],
          )
        ]),
      ),
    );
  }
}

///Displays a dialog when a relevant button is clicked
///@param context Build context
///@param title Label of the dialog
///@param content To provide a column of input text fields to display in the dialog
showAlertDialog(BuildContext context, String title, Column content, edit) {
  ///creates alert dialog and shows it in the given context
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, StateSetter setState) {
        return AlertDialog(
          title: Text("Update $title"),
          content: content,
          actions: [
            ///cancel button in case user changes their mind
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            ///confirm button for user to submit the new data
            TextButton(
              child: const Text("Confirm"),
              //TO-DO
              //problem: value doesn't change
              onPressed: () {
                setState(() {
                  edit;
                  Navigator.pop(context);
                });
              },
            )
          ],
        );
      });
    },
  );
}

///A Container class to show statistics when the button is clicked
class StatsContainer extends StatelessWidget {
  ///Constructor for the Container class
  const StatsContainer(this._isContainerVisible, {super.key});

  ///@param isContainerVisible To determine the size of the container
  final bool _isContainerVisible;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: AnimatedContainer(
            duration: const Duration(seconds: 1),

            ///background color
            color: Colors.white,

            ///the size of the container
            height: _isContainerVisible ? 150.0 : 0.0,
            width: _isContainerVisible ? 500.0 : 0.0));
  }
}
