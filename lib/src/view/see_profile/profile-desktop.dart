import 'package:flutter/material.dart';
import 'package:queasy/constants/app_themes.dart';
import 'package:queasy/src/view/see_profile/profile-view-controller.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

class UserProfileDesktop extends StatefulWidget {
  final ProfileViewController controller = ProfileViewController();

  UserProfileDesktop({Key? key}) : super(key: key);

  ///creates ProfileView class
  @override
  State<UserProfileDesktop> createState() => ProfileDesktopState();
}

class ProfileDesktopState extends State<UserProfileDesktop> {
  get controller => widget.controller;

  TextEditingController firstname = new TextEditingController();
  TextEditingController lastname = new TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController bio = new TextEditingController();
  TextEditingController currentPassword = new TextEditingController();
  TextEditingController newPassword = new TextEditingController();
  TextEditingController email = new TextEditingController();

  bool passwordVisible = false;
  bool errorCurrentPassword = false;
  bool errorConfirmPassword = false;
  final formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .05,
                      left: MediaQuery.of(context).size.width / 2.8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ProfilePicture(
                          name: 'Username',
                          radius: 30,
                          fontsize: 25,
                          //img: '',
                        ),
                        Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(
                              left: 15,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                    bottom: 7,
                                  ),
                                  child: Text(controller.player.username),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    bottom: 7,
                                  ),
                                  child: Text("1 Followers - 2 Following"),
                                ),
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
                                                      alignment:
                                                          Alignment.topCenter,
                                                      child: Text(
                                                        "Edit Profile",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
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
                                                            child: Text(
                                                                "Cancel",
                                                                style: TextStyle(
                                                                    color:
                                                                        black)),
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
                                                          ElevatedButton(
                                                            child: Text(
                                                                "Confirm",
                                                                style: TextStyle(
                                                                    color:
                                                                        black)),
                                                            onPressed: () {
                                                              if (formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                if (username
                                                                    .text
                                                                    .isNotEmpty) {
                                                                  controller.editUsername(
                                                                      controller
                                                                          .player
                                                                          .username,
                                                                      username
                                                                          .text);
                                                                }
                                                                if (bio.text
                                                                    .isNotEmpty) {
                                                                  controller.editBio(
                                                                      controller
                                                                          .player
                                                                          .username,
                                                                      bio.text);
                                                                }
                                                                if (firstname
                                                                        .text
                                                                        .isNotEmpty &&
                                                                    lastname
                                                                        .text
                                                                        .isNotEmpty) {
                                                                  controller.editName(
                                                                      controller
                                                                          .player
                                                                          .username,
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
                                                                      controller
                                                                          .player
                                                                          .username,
                                                                      firstname
                                                                          .text,
                                                                      controller
                                                                          .player
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
                                                                    controller
                                                                        .player
                                                                        .username,
                                                                    controller
                                                                        .player
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
                                                                      controller
                                                                          .player
                                                                          .email);
                                                                }
                                                                ;
                                                                if (email.text
                                                                    .isNotEmpty) {
                                                                  controller.editEmail(
                                                                      controller
                                                                          .player
                                                                          .email,
                                                                      email
                                                                          .text,
                                                                      currentPassword
                                                                          .text);
                                                                }
                                                                bool success = controller
                                                                    .editAllProfile(
                                                                        currentPassword
                                                                            .text);
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
                                                                          Colors
                                                                              .teal,
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
                                                        child: Form(
                                                          key: formKey,
                                                          child: Row(
                                                            children: [
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
                                                              SizedBox(
                                                                  width: 25),
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
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
                                                                              validator: (value) {
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
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                                    child: Text("Edit Profile"))
                              ],
                            ))
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .05,
                    ),
                    child: Container(
                        padding: EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Bio"),
                              Text(controller.player.bio)
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(color: orange))),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .05,
                        left: MediaQuery.of(context).size.width / 6),
                    child: Container(
                        width: MediaQuery.of(context).size.width / 2.2,
                        height: MediaQuery.of(context).size.height * .40,
                        padding: EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("Personal Statistics"),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [Text("5"), Text("completed")],
                                  ),
                                  SizedBox(width: 50),
                                  Column(
                                    children: [Text("5"), Text("10/10 %")],
                                  ),
                                ],
                              ),
                              Text("Score Distribution"),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(color: orange))),
                  ),
                ]),
          ),
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
          )
        ],
      ),
    );
  }
}
