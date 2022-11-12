import 'package:flutter/material.dart';

import 'widgets/custom_bottom_nav_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(pageTitle: 'Home'),
      body: Center(
        child: Stack(children: [
          ///user profile at the top right corner
          Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                  icon: Container(
                    height: 66,
                    width: 66,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            "https://picsum.photos/500/300?random=1"),
                      ),
                    ),
                  ),
                  onPressed: () {})),
          Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                const Icon(
                  Icons.home,
                  size: 200,
                ),
                TextButton(
                  child: const Text("Public Tournaments"),
                  onPressed: () {},
                ),
                TextButton(
                  child: const Text("Join Quiz"),
                  onPressed: () {},
                ),
                TextButton(
                  child: const Text("My Quizzes"),
                  onPressed: () {},
                ),
                TextButton(
                  child: const Text("Leaderboards"),
                  onPressed: () {},
                )
              ],
            ),
          )
        ]),
      ), //text with welcome message,
    );
  }
}
