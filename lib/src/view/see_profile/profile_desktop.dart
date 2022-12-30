import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/constants/app_themes.dart';
import 'package:queasy/src/theme_button.dart';
import 'package:queasy/src/view/see_profile/profile_view_controller.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

import '../../theme_provider.dart';
import '../registration/register_view.dart';
import 'profile_provider.dart';

///This is UserProfileDesktop view
///It displays web version of the profile page
class UserProfileDesktop extends StatefulWidget {
  ///[controller] is ProfileViewController
  final ProfileViewController controller = ProfileViewController();

  UserProfileDesktop({Key? key}) : super(key: key);

  ///creates UserProfileDesktop class
  @override
  State<UserProfileDesktop> createState() => ProfileDesktopState();
}

class ProfileDesktopState extends State<UserProfileDesktop> {
  ///[controller] is ProfileViewController
  get controller => widget.controller;

  ///Text editing controllers to save user input
  TextEditingController firstname = new TextEditingController();
  TextEditingController lastname = new TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController bio = new TextEditingController();
  TextEditingController currentPassword = new TextEditingController();
  TextEditingController newPassword = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController emailForDelete = new TextEditingController();
  TextEditingController passwordForDelete = new TextEditingController();

  ///[passwordVisible] is for user to hide/show the entered password
  bool passwordVisible = false;

  ///[errorCurrentPassword] is to display error message when current password is not entered
  bool errorCurrentPassword = false;

  ///[errorDeletePassword] is to display error message when password entered in delete account container is not entered
  bool errorDeletePassword = false;

  ///[errorDeleteEmail] is to display error message when email entered in delete account container is not entered
  bool errorDeleteEmail = false;

  ///[formKey] used for Form in EditProfile button
  final formKey = GlobalKey<FormState>();

  ///[formKeyDelete] used for Form in DeleteAccount button
  final formKeyDelete = GlobalKey<FormState>();

  ///[features] is to store data used for line graph. Scores must be represented as decimals (eg. 3 points = 0.3).
  final List<Feature> features = [
    Feature(
      title: "Public Quizzes",
      color: purple,
      data: [0.3, 0.6, 0.8, 0.9, 1, 1.2],
    ),
  ];

  @override
  void dispose() {
    /// Cleans up the controllers when the widget is disposed.
    firstname.dispose();
    lastname.dispose();
    username.dispose();
    bio.dispose();
    currentPassword.dispose();
    newPassword.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
  }

  /// Builds the view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ///[Container] used for design
          Container(
              alignment: Alignment.topRight,
              child: Container(
                  height: MediaQuery.of(context).size.height * .30,
                  width: MediaQuery.of(context).size.width / 3,
                  decoration: BoxDecoration(
                      color: green,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                      )))),

          ///[Container] used for design
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * .20,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width / 9,
              height: MediaQuery.of(context).size.height * .50,
              decoration: BoxDecoration(
                  color: orange,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
            ),
          ),

          ///[Container] used for design
          Container(
            alignment: Alignment.bottomRight,
            child: Container(
              height: MediaQuery.of(context).size.height * .12,
              width: MediaQuery.of(context).size.width / 1.7,
              decoration: BoxDecoration(
                  color: white,
                  borderRadius:
                      const BorderRadius.only(topLeft: Radius.circular(20))),
            ),
          ),

          ///[SingleChildScrollView] to avoid overflow
          SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .05,
                      // left: MediaQuery.of(context).size.width / 2.8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ///[MouseRegion] to show user profile picture in a round circle, shows colored circle with first letter of username if  no profile picture has been selected before
                        MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                                onTap: () => {
                                      controller
                                          .pickProfilePicture()
                                          .then((value) => {
                                                if (value)
                                                  {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content:
                                                            Text('Successful!'),
                                                        backgroundColor:
                                                            const Color(
                                                                0xff9fc490),
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        width: 200,
                                                        shape: StadiumBorder(),
                                                      ),
                                                    )
                                                  }
                                              })
                                    },
                                child: Provider.of<ProfileProvider>(context)
                                            .profilePicture ==
                                        ""
                                    ? ProfilePicture(
                                        name: Provider.of<ProfileProvider>(
                                                context)
                                            .username,
                                        radius: 100,
                                        fontsize: 25,
                                      )
                                    : CircleAvatar(
                                        radius: 100,
                                        backgroundColor:
                                            Provider.of<ThemeProvider>(context)
                                                .currentTheme
                                                .colorScheme
                                                .background,
                                        backgroundImage: NetworkImage(
                                            Provider.of<ProfileProvider>(
                                                    context)
                                                .profilePicture)))),
                        Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(
                              left: 15,
                            ),
                            child: Column(
                              children: [
                                ///[Container] to show username
                                Container(
                                  padding: EdgeInsets.only(
                                    bottom: 7,
                                  ),
                                  child: Text(
                                    Provider.of<ProfileProvider>(context)
                                        .username,
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),

                                ///[Container] to show the number of user's followers and following
                                // Container(
                                //   padding: EdgeInsets.only(
                                //     bottom: 7,
                                //   ),
                                //   child: Text("1 Followers - 2 Following",
                                //       style: TextStyle(fontSize: 30)),
                                // ),

                                ///[Container] to show first and last names of the user
                                Container(
                                  padding: EdgeInsets.only(
                                    bottom: 7,
                                  ),
                                  child: Text(
                                      "${Provider.of<ProfileProvider>(context).firstName} ${Provider.of<ProfileProvider>(context).lastName}"),
                                ),

                                ///[Container] to show email of the user
                                Container(
                                  padding: EdgeInsets.only(
                                    bottom: 7,
                                  ),
                                  child: Text(
                                      Provider.of<ProfileProvider>(context)
                                          .email),
                                ),

                                ///[ElevatedButton] to enable the user to edit their profile info
                                ///it opens a new dialog that contains TextFields
                                ElevatedButton(
                                    onPressed: () => {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(builder:
                                                    (context,
                                                        StateSetter setState) {
                                                  if (MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      700) {
                                                    Navigator.of(context).pop();
                                                  }
                                                  return AlertDialog(
                                                    backgroundColor: purple,
                                                    scrollable: true,
                                                    title: Container(
                                                      width: 200,
                                                      height: 50,
                                                      alignment:
                                                          Alignment.topCenter,
                                                      child: Text(
                                                        "Edit Profile",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 30),
                                                      ),
                                                    ),
                                                    actions: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          ///[ElevatedButton] to close the dialog if user wants to exit
                                                          ElevatedButton(
                                                            child: Text(
                                                                "Cancel",
                                                                style: TextStyle(
                                                                    color:
                                                                        black)),

                                                            ///if clicked clears all the text editing controllers
                                                            onPressed: () => {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(),
                                                              username.clear(),
                                                              firstname.clear(),
                                                              lastname.clear(),
                                                              bio.clear(),
                                                              currentPassword
                                                                  .clear(),
                                                              newPassword
                                                                  .clear(),
                                                              newPassword
                                                                  .clear(),
                                                            },
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all<
                                                                            Color>(
                                                                        orange),
                                                                shape: MaterialStateProperty.all<
                                                                        RoundedRectangleBorder>(
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              18.0),
                                                                ))),
                                                          ),

                                                          ///[ElevatedButton] to confirm the changes to the profile info
                                                          ElevatedButton(
                                                            child: Text(
                                                                "Confirm",
                                                                style: TextStyle(
                                                                    color:
                                                                        black)),
                                                            onPressed: () {
                                                              ///when clicked, if form has been successfully validated then
                                                              ///it calls different edit methods depending on which text field is not empty
                                                              if (formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                if (username
                                                                    .text
                                                                    .isNotEmpty) {
                                                                  controller.editUsername(
                                                                      username
                                                                          .text);
                                                                }
                                                                if (bio.text
                                                                    .isNotEmpty) {
                                                                  controller
                                                                      .editBio(bio
                                                                          .text);
                                                                }
                                                                if (firstname
                                                                        .text
                                                                        .isNotEmpty &&
                                                                    lastname
                                                                        .text
                                                                        .isNotEmpty) {
                                                                  controller.editName(
                                                                      firstname
                                                                          .text,
                                                                      lastname
                                                                          .text);
                                                                }
                                                                if (firstname
                                                                        .text
                                                                        .isNotEmpty &&
                                                                    lastname
                                                                        .text
                                                                        .isEmpty) {
                                                                  controller.editName(
                                                                      firstname
                                                                          .text,
                                                                      Provider.of<ProfileProvider>(
                                                                              context)
                                                                          .lastName);
                                                                }
                                                                if (firstname
                                                                        .text
                                                                        .isEmpty &&
                                                                    lastname
                                                                        .text
                                                                        .isNotEmpty) {
                                                                  controller
                                                                      .editName(
                                                                    Provider.of<ProfileProvider>(
                                                                            context)
                                                                        .firstName,
                                                                    lastname
                                                                        .text,
                                                                  );
                                                                }
                                                                if (newPassword
                                                                    .text
                                                                    .isNotEmpty) {
                                                                  controller.editPassword(
                                                                      currentPassword
                                                                          .text,
                                                                      newPassword
                                                                          .text,
                                                                      Provider.of<ProfileProvider>(
                                                                              context)
                                                                          .email);
                                                                }
                                                                ;
                                                                if (email.text
                                                                    .isNotEmpty) {
                                                                  controller.editEmail(
                                                                      Provider.of<ProfileProvider>(
                                                                              context)
                                                                          .email,
                                                                      email
                                                                          .text,
                                                                      currentPassword
                                                                          .text);
                                                                }

                                                                ///editAllProfile method is called from the controller
                                                                ///result is saved in [success] variable
                                                                bool success = controller
                                                                    .editAllProfile(
                                                                        currentPassword
                                                                            .text);

                                                                ///if successful, then snackbar is shown and the dialog is exited
                                                                ///and all the text editing controllers are cleared
                                                                if (success) {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    const SnackBar(
                                                                      content: Text(
                                                                          'Successful!'),
                                                                      backgroundColor:
                                                                          const Color(
                                                                              0xff9fc490),
                                                                      behavior:
                                                                          SnackBarBehavior
                                                                              .floating,
                                                                      width:
                                                                          200,
                                                                      shape:
                                                                          StadiumBorder(),
                                                                    ),
                                                                  );
                                                                  newPassword
                                                                      .clear();
                                                                  currentPassword
                                                                      .clear();
                                                                  lastname
                                                                      .clear();
                                                                  firstname
                                                                      .clear();
                                                                  bio.clear();
                                                                  username
                                                                      .clear();
                                                                  email.clear();
                                                                }
                                                              }
                                                            },
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty
                                                                        .all<Color>(
                                                                            green),
                                                                shape: MaterialStateProperty.all<
                                                                        RoundedRectangleBorder>(
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              18.0),
                                                                ))),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                    content: Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            .80,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            1.5,

                                                        ///[Form] to validate user input (in this case only current password)
                                                        child: Form(
                                                          key: formKey,
                                                          child: Row(
                                                            children: [
                                                              ///[Column] displays the labels for text fields
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  Text(
                                                                      "First name",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                  Text(
                                                                      "Last name",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                  Text(
                                                                      "Username",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                  Text("Bio",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                  Text("Email",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                  Text(
                                                                      "Current Password *",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                  Text(
                                                                      "New Password",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                ],
                                                              ),

                                                              ///[SizedBox] to set space between labels and text fields
                                                              SizedBox(
                                                                  width: 25),

                                                              ///[Column] shows text fields for the user to enter input
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  ///[Container] which includes [TextFormField] for first name
                                                                  Container(
                                                                    height: 30,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        3,
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          firstname,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        contentPadding: EdgeInsets.only(
                                                                            bottom:
                                                                                15,
                                                                            left:
                                                                                20),
                                                                        filled:
                                                                            true,
                                                                        fillColor:
                                                                            Colors.white,
                                                                        border:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(color: Colors.white),
                                                                          borderRadius:
                                                                              BorderRadius.circular(25.7),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  ///[Container] which includes [TextFormField] for last name
                                                                  Container(
                                                                    height: 30,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        3,
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          lastname,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        contentPadding: EdgeInsets.only(
                                                                            bottom:
                                                                                15,
                                                                            left:
                                                                                20),
                                                                        filled:
                                                                            true,
                                                                        fillColor:
                                                                            Colors.white,
                                                                        border:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(color: Colors.white),
                                                                          borderRadius:
                                                                              BorderRadius.circular(25.7),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  ///[Container] which includes [TextFormField] for username
                                                                  Container(
                                                                    height: 30,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        3,
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          username,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        contentPadding: EdgeInsets.only(
                                                                            bottom:
                                                                                15,
                                                                            left:
                                                                                20),
                                                                        filled:
                                                                            true,
                                                                        fillColor:
                                                                            Colors.white,
                                                                        border:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(color: Colors.white),
                                                                          borderRadius:
                                                                              BorderRadius.circular(25.7),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  ///[Container] which includes [TextFormField] for bio
                                                                  Container(
                                                                    height: 50,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        3,
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          bio,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        contentPadding: EdgeInsets.only(
                                                                            bottom:
                                                                                15,
                                                                            left:
                                                                                20),
                                                                        filled:
                                                                            true,
                                                                        fillColor:
                                                                            Colors.white,
                                                                        border:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(color: Colors.white),
                                                                          borderRadius:
                                                                              BorderRadius.circular(25.7),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  ///[Container] which includes [TextFormField] for email
                                                                  Container(
                                                                    height: 30,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width /
                                                                        3,
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          email,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        contentPadding: EdgeInsets.only(
                                                                            bottom:
                                                                                15,
                                                                            left:
                                                                                20),
                                                                        filled:
                                                                            true,
                                                                        fillColor:
                                                                            Colors.white,
                                                                        border:
                                                                            UnderlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(color: Colors.white),
                                                                          borderRadius:
                                                                              BorderRadius.circular(25.7),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Stack(
                                                                      children: [
                                                                        ///[Container] which includes [TextFormField] for current password
                                                                        Container(
                                                                            height:
                                                                                30,
                                                                            width: MediaQuery.of(context).size.width /
                                                                                3,
                                                                            child:
                                                                                TextFormField(
                                                                              ///hides/shows password based on user click
                                                                              obscureText: !passwordVisible,

                                                                              ///if the user hasn't entered anything, validation fails
                                                                              ///and the corresponding error message is displayed
                                                                              validator: (value) {
                                                                                //initially false
                                                                                setState(() {
                                                                                  errorCurrentPassword = false;
                                                                                });
                                                                                if (value == null || value.isEmpty) {
                                                                                  setState(() {
                                                                                    errorCurrentPassword = true;
                                                                                  });
                                                                                  return null;
                                                                                }
                                                                                return null;
                                                                              },
                                                                              controller: currentPassword,
                                                                              decoration: InputDecoration(
                                                                                errorStyle: TextStyle(
                                                                                  color: Colors.white,
                                                                                ),
                                                                                contentPadding: EdgeInsets.only(bottom: 15, left: 20),
                                                                                filled: true,
                                                                                fillColor: Colors.white,
                                                                                border: UnderlineInputBorder(
                                                                                  borderSide: BorderSide(color: Colors.white),
                                                                                  borderRadius: BorderRadius.circular(25.7),
                                                                                ),

                                                                                ///[IconButton] to click when user wants to see/hide password
                                                                                suffixIcon: IconButton(
                                                                                  icon: Icon(
                                                                                    passwordVisible ? Icons.visibility : Icons.visibility_off,
                                                                                    color: Theme.of(context).primaryColorDark,
                                                                                  ),
                                                                                  onPressed: () {
                                                                                    setState(() {
                                                                                      passwordVisible = !passwordVisible;
                                                                                    });
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            )),

                                                                        ///if validation failed then error message is displayed under text field
                                                                        ///if not then empty container which is not seen by the user
                                                                        errorCurrentPassword
                                                                            ? Container(
                                                                                padding: EdgeInsets.only(top: 30, left: 20),
                                                                                child: Text(
                                                                                  "Please enter password",
                                                                                  style: TextStyle(
                                                                                    color: white,
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : Container()
                                                                      ]),

                                                                  ///[Container] which includes [TextFormField] for new password
                                                                  Container(
                                                                      height:
                                                                          30,
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          3,
                                                                      child:
                                                                          TextFormField(
                                                                        ///hides/shows password based on user click
                                                                        obscureText:
                                                                            !passwordVisible,

                                                                        controller:
                                                                            newPassword,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          contentPadding: EdgeInsets.only(
                                                                              bottom: 15,
                                                                              left: 20),
                                                                          filled:
                                                                              true,
                                                                          fillColor:
                                                                              Colors.white,
                                                                          border:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(color: Colors.white),
                                                                            borderRadius:
                                                                                BorderRadius.circular(25.7),
                                                                          ),

                                                                          ///[IconButton] to click when user wants to see/hide password
                                                                          suffixIcon:
                                                                              IconButton(
                                                                            icon:
                                                                                Icon(
                                                                              passwordVisible ? Icons.visibility : Icons.visibility_off,
                                                                              color: Theme.of(context).primaryColorDark,
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              setState(() {
                                                                                passwordVisible = !passwordVisible;
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                      )),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  );
                                                });
                                              })
                                        },

                                    ///[ButtonStyle] to customise the button
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: purple,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        )),

                                    ///[Text] to set the name of the button
                                    child: Text(
                                      "Edit Profile",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                Container(
                                    padding: EdgeInsets.only(top: 7),
                                    child: ElevatedButton(
                                      onPressed: () => {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return StatefulBuilder(builder:
                                                  (context,
                                                      StateSetter setState) {
                                                return AlertDialog(
                                                  backgroundColor: purple,
                                                  scrollable: true,
                                                  title: Container(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    child: Text(
                                                      "Delete Account",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  actions: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        ElevatedButton(
                                                          child: Text("Cancel",
                                                              style: TextStyle(
                                                                  color:
                                                                      black)),
                                                          onPressed: () => {
                                                            Navigator.of(
                                                                    context)
                                                                .pop()
                                                          },
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all<Color>(
                                                                          orange),
                                                              shape: MaterialStateProperty.all<
                                                                      RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            18.0),
                                                              ))),
                                                        ),
                                                        ElevatedButton(
                                                          child: Text("Confirm",
                                                              style: TextStyle(
                                                                  color:
                                                                      black)),
                                                          onPressed: () {
                                                            bool success = controller
                                                                .deleteAccount(
                                                                    emailForDelete
                                                                        .text,
                                                                    passwordForDelete
                                                                        .text);
                                                            if (formKeyDelete
                                                                .currentState!
                                                                .validate()) {
                                                              if (success) {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                RegisterView()));
                                                                emailForDelete
                                                                    .clear();
                                                                passwordForDelete
                                                                    .clear();
                                                              } else {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                      content: Text(
                                                                          'Failed to delete account!'),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                      behavior:
                                                                          SnackBarBehavior
                                                                              .floating,
                                                                      width:
                                                                          200,
                                                                      shape:
                                                                          StadiumBorder()),
                                                                );
                                                              }
                                                            }
                                                          },
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all<Color>(
                                                                          green),
                                                              shape: MaterialStateProperty.all<
                                                                      RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            18.0),
                                                              ))),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                  content: Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .25,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.5,
                                                      child: Form(
                                                        key: formKeyDelete,
                                                        child: Row(
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Text("Email",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white)),
                                                                Text("Password",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white)),
                                                              ],
                                                            ),
                                                            SizedBox(width: 25),
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Stack(
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            30,
                                                                        width:
                                                                            MediaQuery.of(context).size.width /
                                                                                3,
                                                                        child:
                                                                            TextFormField(
                                                                          ///if the user hasn't entered anything, validation fails
                                                                          validator:
                                                                              (value) {
                                                                            setState(() {
                                                                              errorDeleteEmail = false;
                                                                            });
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              setState(() {
                                                                                errorDeleteEmail = true;
                                                                              });
                                                                              return null;
                                                                            }
                                                                            return null;
                                                                          },
                                                                          controller:
                                                                              emailForDelete,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            contentPadding:
                                                                                EdgeInsets.only(bottom: 15, left: 20),
                                                                            filled:
                                                                                true,
                                                                            fillColor:
                                                                                Colors.white,
                                                                            border:
                                                                                UnderlineInputBorder(
                                                                              borderSide: BorderSide(color: Colors.white),
                                                                              borderRadius: BorderRadius.circular(25.7),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      errorDeleteEmail
                                                                          ? Container(
                                                                              padding: EdgeInsets.only(top: 30, left: 20),
                                                                              child: Container(
                                                                                  width: MediaQuery.of(context).size.width / 4,
                                                                                  child: Text(
                                                                                    "Please enter email",
                                                                                    style: TextStyle(
                                                                                      color: white,
                                                                                    ),
                                                                                  )),
                                                                            )
                                                                          : Container()
                                                                    ]),
                                                                Stack(
                                                                    children: [
                                                                      Container(
                                                                          height:
                                                                              30,
                                                                          width: MediaQuery.of(context).size.width /
                                                                              3,
                                                                          child:
                                                                              TextFormField(
                                                                            ///hides/shows password based on user click
                                                                            obscureText:
                                                                                !passwordVisible,

                                                                            ///if the user hasn't entered anything, validation fails
                                                                            validator:
                                                                                (value) {
                                                                              setState(() {
                                                                                errorDeletePassword = false;
                                                                              });
                                                                              if (value == null || value.isEmpty) {
                                                                                setState(() {
                                                                                  errorDeletePassword = true;
                                                                                });
                                                                                return null;
                                                                              }
                                                                              return null;
                                                                            },
                                                                            controller:
                                                                                passwordForDelete,
                                                                            decoration:
                                                                                InputDecoration(
                                                                              labelText: 'Password',
                                                                              contentPadding: EdgeInsets.only(bottom: 15, left: 20),
                                                                              filled: true,
                                                                              fillColor: Colors.white,
                                                                              border: UnderlineInputBorder(
                                                                                borderSide: BorderSide(color: Colors.white),
                                                                                borderRadius: BorderRadius.circular(25.7),
                                                                              ),

                                                                              ///[IconButton] to click when user wants to see/hide password
                                                                              suffixIcon: IconButton(
                                                                                icon: Icon(
                                                                                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                                                                                  color: Theme.of(context).primaryColorDark,
                                                                                ),
                                                                                onPressed: () {
                                                                                  setState(() {
                                                                                    passwordVisible = !passwordVisible;
                                                                                  });
                                                                                },
                                                                              ),
                                                                            ),
                                                                          )),
                                                                      errorDeletePassword
                                                                          ? Container(
                                                                              padding: EdgeInsets.only(top: 30, left: 20),
                                                                              child: Container(
                                                                                  width: MediaQuery.of(context).size.width / 4,
                                                                                  child: Text(
                                                                                    "Please enter password",
                                                                                    style: TextStyle(
                                                                                      color: white,
                                                                                    ),
                                                                                  )),
                                                                            )
                                                                          : Container()
                                                                    ]),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                );
                                              });
                                            })
                                      },
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ))),
                                      child: Text("Delete Account"),
                                    )),
                                Container(
                                    padding: EdgeInsets.only(top: 7),
                                    child: ThemeButton()),
                              ],
                            ))
                      ],
                    ),
                  ),

                  ///[Container] to display Bio of the user
                  Container(
                    // padding: EdgeInsets.only(
                    //   top: MediaQuery.of(context).size.height * .05,
                    // ),
                    child: Container(
                        margin: EdgeInsets.all(7),
                        padding: EdgeInsets.all(7),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(7),
                                child: Text("Bio"),
                              ),
                              Padding(
                                  padding: EdgeInsets.all(7),
                                  child: Text(
                                      Provider.of<ProfileProvider>(context)
                                          .bio))
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Provider.of<ThemeProvider>(context)
                              .currentTheme
                              .colorScheme
                              .background,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Provider.of<ThemeProvider>(context)
                                  .currentTheme
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.05), //color of shadow
                              spreadRadius: 0, //spread radius
                              blurRadius: 10, // blur radius
                              offset: Offset(
                                  0, 4), // changes position of shadow (x, y)
                            ),
                          ],
                        )),
                  ),

                  ///[Container] to display Personal Statistics of the user
                  Container(
                    // padding: EdgeInsets.only(
                    //   top: MediaQuery.of(context).size.height * .05,
                    //   // left: MediaQuery.of(context).size.width / 6
                    // ),
                    alignment: Alignment.center,
                    child: Container(
                        // width: MediaQuery.of(context).size.width / 2.2,
                        // height: MediaQuery.of(context).size.height * .40,
                        margin: EdgeInsets.all(7),
                        padding: EdgeInsets.all(7),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(7),
                                  child: Text("Personal Statistics")),
                              Padding(
                                  padding: EdgeInsets.all(7),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Text("5"),
                                          Text("completed")
                                        ],
                                      ),
                                      SizedBox(width: 50),
                                      Column(
                                        children: [Text("5"), Text("10/10 %")],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.all(7),
                                  child: Text("Score Distribution")),
                              LineGraph(
                                features: features,
                                size: Size(420, 450),
                                labelX: [
                                  'Quiz 1',
                                  'Quiz 2',
                                  'Quiz 3',
                                  'Quiz 4',
                                  'Quiz 5',
                                  'Quiz 6'
                                ],
                                labelY: ['2', '4', '6', '8', '10'],
                                showDescription: true,
                                graphColor: Provider.of<ThemeProvider>(context)
                                    .currentTheme
                                    .colorScheme
                                    .onBackground,
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Provider.of<ThemeProvider>(context)
                              .currentTheme
                              .colorScheme
                              .background,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Provider.of<ThemeProvider>(context)
                                  .currentTheme
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.05), //color of shadow
                              spreadRadius: 0, //spread radius
                              blurRadius: 10, // blur radius
                              offset: Offset(
                                  0, 4), // changes position of shadow (x, y)
                            ),
                          ],
                        )),
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
