import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:queasy/constants/app_themes.dart';
import 'package:queasy/src/view/see_profile/profile-view-controller.dart';

import '../widgets/custom_bottom_nav_bar.dart';

class UserProfileMobile extends StatefulWidget {
  final ProfileViewController controller = ProfileViewController();

  UserProfileMobile({Key? key}) : super(key: key);

  ///creates ProfileView class
  @override
  State<UserProfileMobile> createState() => ProfileMobileState();
}

class ProfileMobileState extends State<UserProfileMobile> {
  get controller => widget.controller;

  TextEditingController firstname = new TextEditingController();
  TextEditingController lastname = new TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController bio = new TextEditingController();
  TextEditingController controllerCurrentPassword = new TextEditingController();
  TextEditingController controllerNewPassword = new TextEditingController();
  TextEditingController controllerConfirmPassword = new TextEditingController();
  TextEditingController email = new TextEditingController();

  bool passwordVisible = false;

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    /// Cleans up the controllers when the widget is disposed.
    firstname.dispose();
    lastname.dispose();
    username.dispose();
    bio.dispose();
    controllerCurrentPassword.dispose();
    controllerNewPassword.dispose();
    controllerConfirmPassword.dispose();
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
        bottomNavigationBar: const CustomBottomNavBar(pageTitle: 'Profile'),
        body: Stack(children: <Widget>[
          Container(
              alignment: Alignment.topRight,
              child: Container(
                  height: MediaQuery.of(context).size.height * .25,
                  width: MediaQuery.of(context).size.width / 5,
                  decoration: BoxDecoration(
                      color: green,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                      )))),
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * .25,
              right: MediaQuery.of(context).size.width / 40,
            ),
            child: Container(
              width: MediaQuery.of(context).size.width / 1.3,
              height: MediaQuery.of(context).size.height * .50,
              decoration: BoxDecoration(
                  color: orange,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: MediaQuery.of(context).size.height * .70,
              width: MediaQuery.of(context).size.width / 15,
              decoration: BoxDecoration(
                  color: white,
                  borderRadius:
                      const BorderRadius.only(topRight: Radius.circular(20))),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .07, bottom: 7),
                  child: ProfilePicture(
                    name: 'Username',
                    radius: 40,
                    fontsize: 25,
                    //img: '',
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    bottom: 7,
                  ),
                  child: Text("Username"),
                ),
                Container(
                  padding: EdgeInsets.only(
                    bottom: 7,
                  ),
                  child: Text("First name - Last name"),
                ),
                Container(
                  padding: EdgeInsets.only(
                    bottom: 7,
                  ),
                  child: Text("Email"),
                ),
                Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height * .15,
                    padding: EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text("Bio"), Text("Bla bla")],
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    )),
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .05,
                  ),
                  child: Container(
                      width: MediaQuery.of(context).size.width / 2,
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
                Container(
                  padding: EdgeInsets.only(top: 7),
                  child: ElevatedButton(
                      onPressed: () => {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                      builder: (context, StateSetter setState) {
                                    return AlertDialog(
                                      backgroundColor: purple,
                                      scrollable: true,
                                      title: Container(
                                        alignment: Alignment.topCenter,
                                        child: Text(
                                          "Edit Profile",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      actions: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                              child: Text("Cancel",
                                                  style:
                                                      TextStyle(color: black)),
                                              onPressed: () =>
                                                  {Navigator.of(context).pop()},
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(orange),
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                  ))),
                                            ),
                                            ElevatedButton(
                                              child: Text("Confirm",
                                                  style:
                                                      TextStyle(color: black)),
                                              onPressed: () => {},
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(green),
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                  ))),
                                            ),
                                          ],
                                        ),
                                      ],
                                      content: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .80,
                                          width: MediaQuery.of(context)
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
                                                    Text("First name",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    Text("Last name",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    Text("Username",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    Text("Bio",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    Text("Current Password",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    Text("New Password",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    Text("Confirm Password",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ],
                                                ),
                                                SizedBox(width: 25),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 30,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                      child: TextFormField(
                                                        controller: firstname,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  bottom: 15,
                                                                  left: 20),
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                          border:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25.7),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 30,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                      child: TextFormField(
                                                        controller: lastname,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  bottom: 15,
                                                                  left: 20),
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                          border:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25.7),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 30,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                      child: TextFormField(
                                                        controller: username,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  bottom: 15,
                                                                  left: 20),
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                          border:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25.7),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 50,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                      child: TextFormField(
                                                        controller: bio,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  bottom: 15,
                                                                  left: 20),
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                          border:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25.7),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                        height: 30,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3,
                                                        child: TextFormField(
                                                          ///hides/shows password based on user click
                                                          obscureText:
                                                              !passwordVisible,

                                                          ///if the user hasn't entered anything, validation fails
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'Please enter password';
                                                            }
                                                            return null;
                                                          },
                                                          controller:
                                                              controllerCurrentPassword,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Password',
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                                    bottom: 15,
                                                                    left: 20),
                                                            filled: true,
                                                            fillColor:
                                                                Colors.white,
                                                            border:
                                                                UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25.7),
                                                            ),

                                                            ///[IconButton] to click when user wants to see/hide password
                                                            suffixIcon:
                                                                IconButton(
                                                              icon: Icon(
                                                                passwordVisible
                                                                    ? Icons
                                                                        .visibility
                                                                    : Icons
                                                                        .visibility_off,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColorDark,
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  passwordVisible =
                                                                      !passwordVisible;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        )),
                                                    Container(
                                                        height: 30,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3,
                                                        child: TextFormField(
                                                          ///hides/shows password based on user click
                                                          obscureText:
                                                              !passwordVisible,

                                                          ///if the user hasn't entered anything, validation fails
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'Please enter password';
                                                            }
                                                            return null;
                                                          },
                                                          controller:
                                                              controllerNewPassword,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Password',
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                                    bottom: 15,
                                                                    left: 20),
                                                            filled: true,
                                                            fillColor:
                                                                Colors.white,
                                                            border:
                                                                UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25.7),
                                                            ),

                                                            ///[IconButton] to click when user wants to see/hide password
                                                            suffixIcon:
                                                                IconButton(
                                                              icon: Icon(
                                                                passwordVisible
                                                                    ? Icons
                                                                        .visibility
                                                                    : Icons
                                                                        .visibility_off,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColorDark,
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  passwordVisible =
                                                                      !passwordVisible;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        )),
                                                    Container(
                                                        height: 30,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            3.0,
                                                        child: TextFormField(
                                                          ///hides/shows password based on user click
                                                          obscureText:
                                                              !passwordVisible,

                                                          ///if the user hasn't entered anything, validation fails
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'Please enter password';
                                                            }
                                                            return null;
                                                          },
                                                          controller:
                                                              controllerConfirmPassword,
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Password',
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                                    bottom: 15,
                                                                    left: 20),
                                                            filled: true,
                                                            fillColor:
                                                                Colors.white,
                                                            border:
                                                                UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25.7),
                                                            ),

                                                            ///[IconButton] to click when user wants to see/hide password
                                                            suffixIcon:
                                                                IconButton(
                                                              icon: Icon(
                                                                passwordVisible
                                                                    ? Icons
                                                                        .visibility
                                                                    : Icons
                                                                        .visibility_off,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColorDark,
                                                              ),
                                                              onPressed: () {
                                                                setState(() {
                                                                  passwordVisible =
                                                                      !passwordVisible;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ))
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                      child: Text("Edit Profile")),
                ),
                Container(
                    padding: EdgeInsets.only(top: 7),
                    child: ElevatedButton(
                      onPressed: () => {},
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                      child: Text("Sign Out"),
                    )),
                Container(
                    padding: EdgeInsets.only(top: 7),
                    child: ElevatedButton(
                      onPressed: () => {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                  builder: (context, StateSetter setState) {
                                return AlertDialog(
                                  backgroundColor: purple,
                                  scrollable: true,
                                  title: Container(
                                    alignment: Alignment.topCenter,
                                    child: Text(
                                      "Delete Account",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                          child: Text("Cancel",
                                              style: TextStyle(color: black)),
                                          onPressed: () =>
                                              {Navigator.of(context).pop()},
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(orange),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                              ))),
                                        ),
                                        ElevatedButton(
                                          child: Text("Confirm",
                                              style: TextStyle(color: black)),
                                          onPressed: () => {},
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(green),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                              ))),
                                        ),
                                      ],
                                    ),
                                  ],
                                  content: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .15,
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      child: Form(
                                        key: formKey,
                                        child: Row(
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text("Email",
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                Text("Password",
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ],
                                            ),
                                            SizedBox(width: 25),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 30,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3,
                                                  child: TextFormField(
                                                    controller: email,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              bottom: 15,
                                                              left: 20),
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      border:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.white),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25.7),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    height: 30,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3,
                                                    child: TextFormField(
                                                      ///hides/shows password based on user click
                                                      obscureText:
                                                          !passwordVisible,

                                                      ///if the user hasn't entered anything, validation fails
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Please enter password';
                                                        }
                                                        return null;
                                                      },
                                                      controller:
                                                          controllerCurrentPassword,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Password',
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                bottom: 15,
                                                                left: 20),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        border:
                                                            UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25.7),
                                                        ),

                                                        ///[IconButton] to click when user wants to see/hide password
                                                        suffixIcon: IconButton(
                                                          icon: Icon(
                                                            passwordVisible
                                                                ? Icons
                                                                    .visibility
                                                                : Icons
                                                                    .visibility_off,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColorDark,
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              passwordVisible =
                                                                  !passwordVisible;
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                      child: Text("Delete Account"),
                    )),
              ],
            ),
          )
        ]));
  }
}
