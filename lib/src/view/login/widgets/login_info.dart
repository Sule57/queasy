/// ****************************************************************************
/// Created by Julia Agüero
/// Collaborators: Gullu Gasimova
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/constants/theme_provider.dart';
import 'package:queasy/src/view/home_view.dart';
import 'package:queasy/src/view/login/login_provider.dart';
import 'package:queasy/src/view/login/widgets/social_media_buttons.dart';
import 'package:queasy/src/view/registration/register_view.dart';
import 'package:queasy/src/view/widgets/rounded-button.dart';

import 'forgot_password_dialog.dart';

class LoginInfo extends StatefulWidget {
  const LoginInfo({Key? key}) : super(key: key);

  @override
  State<LoginInfo> createState() => _LoginInfoState();
}

class _LoginInfoState extends State<LoginInfo> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    LoginProvider controller = Provider.of<LoginProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context).currentTheme;
    final errorTextStyle = themeProvider.textTheme.subtitle2!;
    final _formKey = width > 700
        ? controller.loginFormKeyDesktop
        : controller.loginFormKeyMobile;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.errorMessage,
                style: errorTextStyle,
              ),
              TextFormField(
                controller: controller.emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: controller.validateEmail,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
                textInputAction: TextInputAction.next,
                // onFieldSubmitted: (value) {
                //   if (controller.loginFormKey.currentState!.validate()) {
                //     controller.signInWithEmailAndPassword();
                //   }
                // },
              ),
              TextFormField(
                controller: controller.passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordObscured
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () => controller.togglePasswordVisibility(),
                  ),
                ),
                obscureText: controller.isPasswordObscured,
                validator: controller.validatePassword,
                onFieldSubmitted: (value) async {
                  if (_formKey.currentState!.validate()) {
                    bool success =
                        await controller.signInWithEmailAndPassword();
                    if (success) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeView()),
                      );
                    }
                  }
                },
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const ForgotPasswordDialog(),
                    );
                  },
                  child: const Text('Forgot Password?'),
                ),
              ),
              RoundedButton(
                buttonName: 'Log in',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    bool success =
                        await controller.signInWithEmailAndPassword();
                    if (success) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeView()),
                      );
                    }
                  }
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: const Divider(
                  endIndent: 10,
                  color: Colors.grey,
                  height: 36,
                  thickness: 1.0,
                ),
              ),
              Text(
                "or log in with",
                style: themeProvider.textTheme.bodyText1,
              ),
              Expanded(
                child: const Divider(
                  indent: 10,
                  color: Colors.grey,
                  height: 36,
                  thickness: 1.0,
                ),
              ),
            ],
          ),
          SocialMediaButtons(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "New User?",
                style: themeProvider.textTheme.bodyText1,
              ),
              const SizedBox(width: 5),
              ElevatedButton(
                child: Text('Register'),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                onPressed: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RegisterView()),
                  )
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
