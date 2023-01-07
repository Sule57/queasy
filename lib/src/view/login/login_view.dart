import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/src/view/login/widgets/desktop_background.dart';
import 'package:queasy/src/view/login/widgets/login_info.dart';

import 'login_provider.dart';

/// This is the mobile version of the login view.
///
/// It is the view that the user sees when they are trying to sign in to
/// use the app. It shows two fields for the user to fill in, and a button
/// to sign up. When the login is over, the user is taken to [HomeView].
class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late LoginProvider controller;

  @override
  void didChangeDependencies() {
    controller = Provider.of<LoginProvider>(context, listen: false);
    controller.forgotPasswordController = TextEditingController();
    controller.passwordController = TextEditingController();
    controller.emailController = TextEditingController();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.forgotPasswordController.dispose();
    controller.passwordController.dispose();
    controller.emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width > 700 ? LoginViewDesktop() : LoginViewMobile();
  }
}

class LoginViewMobile extends StatelessWidget {
  const LoginViewMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: height,
            width: width,
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/assets/images/logo_vertical.png',
                  height: height / 4,
                  fit: BoxFit.fitHeight,
                ),
                const SizedBox(height: 20),
                Expanded(child: LoginInfo()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginViewDesktop extends StatelessWidget {
  const LoginViewDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          DesktopBackground(),
          Center(
            child: Container(
              height: height / 1.5,
              width: width / 0.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'lib/assets/images/logo_vertical.png',
                      width: width / 3,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: width / 3,
                    child: LoginInfo(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
