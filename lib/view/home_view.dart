import 'package:flutter/material.dart';

import 'widgets/custom_bottom_nav_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: CustomBottomNavBar(pageTitle: 'Home'),
      body: Center(
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'Login Successful',
            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
          ),
        ),
      ), //text with welcome message,
    );
  }
}
