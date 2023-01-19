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
import 'package:queasy/src/view/login/login_provider.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LoginProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context).currentTheme;
    final titleTextStyle = themeProvider.textTheme.headline5!.copyWith(
      color: themeProvider.colorScheme.onPrimary,
    );
    ;
    final bodyTextStyle = themeProvider.textTheme.subtitle1!.copyWith(
      color: themeProvider.colorScheme.onPrimary,
    );

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: themeProvider.colorScheme.primary,
      title: Text(
        'Forgot Password?',
        style: titleTextStyle,
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * .20,
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'We will send you a link to reset your password',
              style: bodyTextStyle,
            ),
            Form(
              key: controller.forgotPasswordFormKey,
              child: TextFormField(
                controller: controller.forgotPasswordController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: themeProvider.colorScheme.onPrimary,
                  hintText: 'Email',
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                ),
                validator: controller.validateEmail,
                // onFieldSubmitted: (value) {
                //   if (controller.forgotPasswordFormKey.currentState!
                //       .validate()) {
                //     print(controller.forgotPasswordController.text);
                //     controller.sendForgotPasswordEmail();
                //     controller.forgotPasswordController.clear();
                //     Navigator.pop(context);
                //   }
                // },
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  themeProvider.colorScheme.secondary,
                ),
              ),
            ),
            ElevatedButton(
              child: Text('Send'),
              onPressed: () {
                if (controller.forgotPasswordFormKey.currentState!.validate()) {
                  controller.sendForgotPasswordEmail();
                  controller.forgotPasswordController.clear();
                  Navigator.pop(context);
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  themeProvider.colorScheme.tertiary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
