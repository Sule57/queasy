import 'package:flutter/material.dart';
import 'package:queasy/constants/app_themes.dart';
import 'package:queasy/view/login_view.dart';
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

  List<TextEditingController> textController =
      List.generate(15, (i) => TextEditingController());

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
                              controller: textController[1],
                              decoration: const InputDecoration(
                                labelText: 'Enter new username',
                              ),
                            ),
                          ]),
                      controller.editUsername(
                          controller.player.username, textController[1].text)),
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
                              controller: textController[3],
                              decoration: const InputDecoration(
                                labelText: 'Enter New Firstname',
                              ),
                            ),

                            ///to enter the new lastname
                            TextField(
                              controller: textController[4],
                              decoration: const InputDecoration(
                                labelText: 'Enter New Lastname',
                              ),
                            ),
                          ]),
                      controller.editName(controller.player.username,
                          textController[3].text, textController[4].text)),
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
                            ///to enter the current username
                            TextField(
                              controller: textController[5],
                              decoration: const InputDecoration(
                                labelText: 'Enter current email',
                                hintText: 'yourname@example.com',
                              ),
                            ),

                            ///to ener the new email
                            TextField(
                              controller: textController[6],
                              decoration: const InputDecoration(
                                labelText: 'Enter New Email',
                                hintText: 'yourname@example.com',
                              ),
                            ),

                            ///to enter the password
                            TextField(
                              controller: textController[7],
                              decoration: const InputDecoration(
                                labelText: 'Enter password',
                              ),
                            ),
                          ]),
                      controller.editEmail(textController[5].text,
                          textController[6].text, textController[7].text)),
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
                          "bio",
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ///to enter new bio information
                                TextField(
                                  controller: textController[9],
                                  decoration: const InputDecoration(
                                    labelText: 'Enter New Bio',
                                  ),
                                ),
                              ]),
                          controller.editBio(controller.player.username,
                              textController[9].text)),
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
                          ///to enter the current username
                          TextField(
                            controller: textController[10],
                            decoration: const InputDecoration(
                              labelText: 'Enter Email',
                            ),
                          ),

                          ///to enter the current password
                          TextField(
                            controller: textController[11],
                            decoration: const InputDecoration(
                              labelText: 'Enter Password',
                            ),
                          ),

                          ///to enter the new password
                          TextField(
                            controller: textController[12],
                            decoration: const InputDecoration(
                              labelText: 'Enter New Password',
                            ),
                          ),
                        ],
                      ),
                      controller.editPassword(textController[10].text,
                          textController[11].text, textController[12].text)),
                ),
              ]),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ///button to sign out
              ElevatedButton(
                child: const Text("Sign out"),
                onPressed: () {
                  setState(() {
                    controller.signOut;
                    if (controller.signOut()) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LogInView(),
                      ));
                    }
                  });
                },
              ),

              ///button to delete the account
              TextButton(
                  child: const Text("Delete Account"),
                  onPressed: () => showAlertDialog(
                        context,
                        "password",
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ///to enter the current username
                              TextField(
                                controller: textController[13],
                                decoration: const InputDecoration(
                                  labelText: 'Enter Email',
                                ),
                              ),

                              ///to enter the current password
                              TextField(
                                controller: textController[14],
                                decoration: const InputDecoration(
                                  labelText: 'Enter Password',
                                ),
                              ),
                            ]),
                        controller.deleteAccount(
                            textController[13].text, textController[14].text),
                      ))
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
              onPressed: () {
                setState(() {
                  edit;
                  if (edit) {
                    Navigator.pop(context);
                  }
                  if (!edit) {
                    throw ErrorHint("failed");
                  }
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
