import 'package:flutter/material.dart';
import 'package:queasy/constants/app_themes.dart';
import 'widgets/custom_bottom_nav_bar.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  ///creates ProfileView class
  @override
  State<UserProfile> createState() => ProfileView();
}

class ProfileView extends State<UserProfile> {
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
                ///profile picture of the user
                Icon(
                  Icons.verified_user,
                  size: 50,
                ),

                ///username
                TextButton(
                  child: Text("Username"),

                  ///opens the dialog when clicked
                  onPressed: () => showAlertDialog(
                      context,
                      "username",
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          //position
                          mainAxisSize: MainAxisSize.min,
                          // wrap content in flutter
                          children: const <Widget>[
                            ///to ener the new username
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Enter New Username',
                              ),
                            ),
                          ])),
                ),

                ///first name and last name of the user
                TextButton(
                  child: Text("first name - last name"),

                  ///opens the dialog when clicked
                  onPressed: () => showAlertDialog(
                      context,
                      "name",
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: const <Widget>[
                            ///to ener the new firstname
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Enter New Firstname',
                              ),
                            ),

                            ///to ener the new lastname
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Enter New Lastname',
                              ),
                            ),
                          ])),
                ),

                ///email of the user
                TextButton(
                  child: Text("Email"),

                  ///opens the dialog when clicked
                  onPressed: () => showAlertDialog(
                      context,
                      "email",
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: const <Widget>[
                            ///to ener the new email
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Enter New Email',
                                hintText: 'yourname@example.com',
                              ),
                            ),
                          ])),
                ),
              ]),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ///displays the bio of the user
                Container(
                  height: 120.0,
                  width: 300.0,
                  padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
                  color: green,
                  child: Column(children: [Text("Bio"), Text("data")]),
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
                          children: const <Widget>[
                            ///to enter the old password
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Enter Password',
                              ),
                            ),

                            ///to enter the new password
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Enter New Password',
                              ),
                            ),

                            ///to confirm the new password
                            TextField(
                              decoration: InputDecoration(
                                labelText: 'Confirm New Password',
                              ),
                            ),
                          ])),
                ),
              ]),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ///button to sign out
              ElevatedButton(
                child: const Text("Sign out"),
                onPressed: () {},
              ),

              ///button to delete the account
              TextButton(
                child: const Text("Delete Account"),
                onPressed: () {},
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
showAlertDialog(BuildContext context, String title, Column content) {
  ///cancel button in case user changes their mind
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  ///confirm button for user to submit the new data
  Widget confirmButton = TextButton(
    child: const Text("Confirm"),
    onPressed: () {},
  );

  ///the alert dialog
  AlertDialog alert = AlertDialog(
    title: Text("Update $title"),
    content: content,
    actions: [
      cancelButton,
      confirmButton,
    ],
  );

  ///shows the dialog in the given context
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
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
