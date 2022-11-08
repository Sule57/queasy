import 'package:flutter/material.dart';
import 'package:queasy/view/widgets/custom_bottom_nav_bar.dart';

class StatisticsView extends StatelessWidget {
  const StatisticsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: CustomBottomNavBar(pageTitle: 'Quiz View'),
      body: Center(
        child: Text('Statistics View'),
      ),
    );
  }
}
