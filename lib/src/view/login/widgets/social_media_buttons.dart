/// ****************************************************************************
/// Created by Julia Agüero
/// Collaborators: Gullu Gasimova
///
/// This file is part of the project "Qeasy"
/// Software Project on Technische Hochschule Ulm
/// ****************************************************************************

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/src/view/home_view.dart';
import 'package:queasy/src/view/login/login_provider.dart';

class SocialMediaButtons extends StatelessWidget {
  const SocialMediaButtons({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LoginProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Image.asset('lib/assets/images/google.png'),
          onPressed: () async {
            bool success = await controller.signInWithGoogle();

            if (success) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeView(),
                ),
              );
            }
          },
        ),
        IconButton(
          icon: Image.asset(
            'lib/assets/images/facebook.png',
          ),
          onPressed: () async {
            bool success = await controller.signInWithFacebook();

            if (success) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeView(),
                ),
              );
            }
          },
        ),
        // IconButton(
        //   icon: Image.asset(
        //     'lib/assets/images/twitter.png',
        //   ),
        //   onPressed: () async {
        //     bool success = await controller.signInWithTwitter();
        //
        //     if (success) {
        //       Navigator.pushReplacement(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => const HomeView(),
        //         ),
        //       );
        //     }
        //   },
        // ),
      ],
    );
  }
}
