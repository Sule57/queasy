import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:queasy/main.dart';
import '../model/leaderboard.dart';
import '../model/leaderboard_entry.dart';
import 'widgets/custom_bottom_nav_bar.dart';

//const List<String> list = <String>['All', 'Art', 'Science', 'Sports'];


class LeaderboardView extends StatefulWidget {
  const LeaderboardView({Key? key}) : super(key: key);

  @override
  State<LeaderboardView> createState() => _LeaderboardView();
}

class _LeaderboardView extends State<LeaderboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(pageTitle: 'Leaderboard'),
        body: Center(
            child: Stack(children: [
              //violet rectangle at the top of the screen
              Container(
                alignment: Alignment.topCenter,
                constraints: const BoxConstraints(
                    minWidth: double.infinity, maxWidth: double.infinity),
                height: 330,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xff72479d),
                ),
              ),
              //dark green rectangle at the right side of the screen
              Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.centerRight,
                      child: Container(
                        width: 200,
                        height: 220,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: const Color(0xff9fc490),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              //light green rectangle at the bottom of the screen
              Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomLeft,
                      child: Container(
                        width: 200,
                        height: 220,
                        //alignment: Alignment.bottomLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: const Color(0xfff1ffe7),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              //ListTiles
              CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    backgroundColor: const Color(0xff72479d),
                    pinned: true,
                    flexibleSpace: const FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text('Science',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 50.0,
                          ) //TextStyle
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            const Divider(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                tileColor: Colors.white,
                                textColor: const Color(0xFFFF8C66),
                                iconColor: Colors.white,
                                leading: index == 0
                                    ? const Text('')
                                    : Container(
                                    height: 25,
                                    width: 25,
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFFF8C66),
                                        shape: BoxShape.circle),
                                    child: Center(
                                        child: Text(
                                          (index + 1).toString(),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ))),
                                title: index == 0
                                    ? Column(
                                  children: [
                                    Container(
                                        height: 25,
                                        width: 25,
                                        decoration: const BoxDecoration(
                                            color: Color(0xFFFF8C66),
                                            shape: BoxShape.circle),
                                        child: Center(
                                            child: Text(
                                              (index + 1).toString(),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ))),
                                    const Text(
                                      'username',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 26),
                                    ),
                                  ],
                                )
                                    : const Text(
                                  'username',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 26),
                                ),
                                subtitle: index == 0 ? const Text(
                                  'points',
                                  textAlign: TextAlign.center,
                                ):
                                const Text(
                                  'points',
                                ),
                                //const Icon(Icons.back_hand_outlined),
                                //subtitle: index == 0 ? const Text('username', textAlign: TextAlign.center,style:TextStyle(color: Colors.black, fontSize: 26),): null,
                              ),
                            ),
                          ],
                        );
                      },
                      childCount: 10,
                    ),
                  ),
                ],
              ),
            ])));
  }
}
