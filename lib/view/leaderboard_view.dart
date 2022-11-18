import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:queasy/main.dart';
import '../auth.dart';
import '../model/leaderboard_entry.dart';
import 'widgets/custom_bottom_nav_bar.dart';
import 'package:queasy/model/leaderboard.dart';

//const List<String> list = <String>['All', 'Science'];


class LeaderboardView extends StatefulWidget {
  const LeaderboardView({Key? key}) : super(key: key);

  @override
  State<LeaderboardView> createState() => _LeaderboardView();
}

//Method to create Leaderboard
late Leaderboard lb;
Future<Leaderboard> create(String category, String username) async {
  lb = await Leaderboard.create(category, username);
  return lb;
}



class _LeaderboardView extends State<LeaderboardView> {
  @override
  Widget build(BuildContext context) {
    String? user = Auth().currentUser!.displayName;
    //Fill method to create Leaderboard with data
    create('All', user!);
    return Scaffold(
        bottomNavigationBar: const CustomBottomNavBar(pageTitle: 'Leaderboard'),
        body: Center(
            child:
            // Build as soon as LeaderboardView receives data from Firebase
            FutureBuilder(
                    future: create('All', 'Anika'),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<LeaderboardEntry> entries = lb.getEntries();
                        return Stack(children: [
                          //violet rectangle at the top of the screen
                          Container(
                            alignment: Alignment.topCenter,
                            constraints: const BoxConstraints(
                                minWidth: double.infinity,
                                maxWidth: double.infinity),
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
                          CustomScrollView(
                            slivers: <Widget>[
                              //fixed App Bar with Text "Leaderboard"
                              SliverAppBar(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                backgroundColor: const Color(0xff72479d),
                                pinned: true,
                                flexibleSpace: FlexibleSpaceBar(
                                  centerTitle: true,
                                  title: Text('Leaderboard',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 50.0,
                                        fontFamily:
                                            GoogleFonts.nunito().fontFamily,
                                      ) //TextStyle
                                      ),
                                ),
                              ),
                              //List Tiles displaying the Top 10 per Category (one person per Tile)
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    return Column(
                                      children: <Widget>[
                                        const Divider(
                                          height: 20,
                                          color: Color(0x00000000),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.white,
                                          ),
                                          child: ListTile(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            tileColor: Colors.white,
                                            textColor: const Color(0xFFFF8C66),
                                            iconColor: Colors.white,
                                            leading: index == 0
                                                ? const Text('')
                                                : Container(
                                                    height: 25,
                                                    width: 25,
                                                    decoration:
                                                        const BoxDecoration(
                                                            color: Color(
                                                                0xFFFF8C66),
                                                            shape: BoxShape
                                                                .circle),
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
                                                          decoration:
                                                              const BoxDecoration(
                                                                  color: Color(
                                                                      0xFFFF8C66),
                                                                  shape: BoxShape
                                                                      .circle),
                                                          child: Center(
                                                              child: Text(
                                                            (index + 1)
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ))),
                                                      //Displaying the username of Top 10
                                                      Text(
                                                        entries.elementAt(index).getName,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 26,
                                                          fontFamily:
                                                          GoogleFonts.nunito().fontFamily,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Text(
                                                    entries.elementAt(index).getName,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 26,
                                                      fontFamily:
                                                      GoogleFonts.nunito().fontFamily),
                                                  ),
                                            subtitle: index == 0
                                            //Displaying the points of Top 10
                                                ? Text(
                                                    '${entries.elementAt(index).getScore} points',
                                                    textAlign: TextAlign.center,
                                                  )
                                                : Text(
                                                    '${entries.elementAt(index).getScore} points',
                                                  ),
                                            trailing: const Text(''),
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
                        ]);
                      }
                      //returns error if Future<Leaderboard> create(String category, String username) async has an error
                      else {
                        return Text('Leaderboard error: ${snapshot.error.toString()}');
                      }
                    },
                  )));
  }
}
