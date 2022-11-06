import 'package:flutter/material.dart';
import 'custom_bottom_nav_bar.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(pageTitle: 'Profile'),
      body: const Center(
        child: Text('Profile View'),
      ),
    );
  }
}
