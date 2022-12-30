import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/src/view/see_leaderboard/leaderboard_provider.dart';
import 'package:queasy/src/view/see_leaderboard/widgets/category_tile_desktop.dart';
import 'package:queasy/src/view/see_leaderboard/widgets/user_tile_desktop.dart';

import '../../theme_provider.dart';

class LeaderboardView extends StatefulWidget {
  const LeaderboardView({Key? key}) : super(key: key);

  @override
  State<LeaderboardView> createState() => _LeaderboardViewState();
}

/// State for [LeaderboardView].
class _LeaderboardViewState extends State<LeaderboardView> {
  /// Builds the view.
  ///
  /// Uses a [Stack] to display the
  /// [LeaderboardDesktopViewBackground] and the [LeaderboardViewContent] on top.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: const [
          LeaderboardDesktopViewBackground(),
          LeaderboardViewContent(),
        ],
      ),
    );
  }
}

/// Background for [LeaderboardView].
///
/// Uses a [StatelessWidget] to display a background color.
class LeaderboardDesktopViewBackground extends StatelessWidget {
  /// Constructor for [LeaderboardDesktopViewBackground].
  const LeaderboardDesktopViewBackground({Key? key}) : super(key: key);

  /// Builds the background.
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return width > 700
        ? Scaffold(
            body: Center(
                child: Stack(children: [
            //dark green rectangle at the top right of the screen
            Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.topRight,
                    child: Container(
                      width: width / 4,
                      height: height / 3,
                      //alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xff9fc490),
                      ),
                    ),
                  ),
                )
              ],
            ),
            //orange rectangle at the bottom left of the screen
            Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomLeft,
                    child: Container(
                      width: width * 2 / 3,
                      height: height / 5,
                      //alignment: Alignment.bottomLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xffF19C79),
                      ),
                    ),
                  ),
                )
              ],
            ),
            //light green rectangle at the bottom right of the screen
            Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomRight,
                    child: Container(
                      width: width / 2,
                      height: height / 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xfff1ffe7),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ])))
        : Container(); //empty container for mobile view
  }
}

/// Content for [LeaderboardView].
///
/// Uses a [StatefulWidget] to display leaerboard and updates the
/// text contained in the widgets.
class LeaderboardViewContent extends StatefulWidget {
  const LeaderboardViewContent({Key? key}) : super(key: key);

  /// Creates a [LeaderboardViewContent] state.
  @override
  State<LeaderboardViewContent> createState() => _LeaderboardViewContentState();
}

/// State for [LeaderboardViewContent].
class _LeaderboardViewContentState extends State<LeaderboardViewContent> {
  /// Builds the content.
  ///
  /// It uses a [Scaffold] to display the different elements of the view:
  /// including [CategoryTileDesktop] and [UserTileDesktop].
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('leaderboard').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return width < 700
              ? const LeaderboardMobileContent()
              : LeaderboardDesktopContent();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class LeaderboardMobileContent extends StatelessWidget {
  const LeaderboardMobileContent({Key? key}) : super(key: key);
  //TODO: manually add all public category names to this list
  static const List<String> list = <String>['All', 'Science'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      Container(
        padding: const EdgeInsets.all(20),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              toolbarHeight: 75,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              backgroundColor: const Color(0xff72479d),
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(Provider.of<LeaderboardProvider>(context).category,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 50.0,
                    ) //TextStyle
                    ),
              ),
              //drop down menu
              actions: [
                Center(
                    child: DropdownButton<String>(
                  hint: Text("Category",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      )),
                  icon: const Icon(Icons.arrow_downward),
                  iconEnabledColor: Colors.white,
                  iconDisabledColor: Colors.white,
                  items:
                      list.map<DropdownMenuItem<String>>((final String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    Provider.of<LeaderboardProvider>(context, listen: false)
                        .setLeaderboard(value!);
                  },
                ))
              ],
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      const Divider(
                        color: Colors.transparent,
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Provider.of<ThemeProvider>(context)
                              .currentTheme
                              .colorScheme
                              .background,
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          tileColor: Provider.of<ThemeProvider>(context)
                              .currentTheme
                              .colorScheme
                              .background,
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
                                    Text(
                                      Provider.of<LeaderboardProvider>(context)
                                          .entries[index]
                                          .getName,
                                      style: TextStyle(
                                          color: Provider.of<ThemeProvider>(
                                                  context)
                                              .currentTheme
                                              .colorScheme
                                              .onBackground,
                                          fontSize: 26),
                                    ),
                                  ],
                                )
                              : Text(
                                  Provider.of<LeaderboardProvider>(context)
                                      .entries[index]
                                      .getName,
                                  style: TextStyle(
                                      color: Provider.of<ThemeProvider>(context)
                                          .currentTheme
                                          .colorScheme
                                          .onBackground,
                                      fontSize: 26),
                                ),
                          subtitle: index == 0
                              ? Text(
                                  Provider.of<LeaderboardProvider>(context)
                                          .entries[index]
                                          .getScore
                                          .toString() +
                                      'points',
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  Provider.of<LeaderboardProvider>(context)
                                          .entries[index]
                                          .getScore
                                          .toString() +
                                      'points',
                                ),
                          //const Icon(Icons.back_hand_outlined),
                          //subtitle: index == 0 ? const Text('username', textAlign: TextAlign.center,style:TextStyle(color: Colors.black, fontSize: 26),): null,
                        ),
                      ),
                    ],
                  );
                },
                childCount:
                    Provider.of<LeaderboardProvider>(context).totalEntries,
              ),
            ),
          ],
        ),
      ),
    ])));
  }
}

class LeaderboardDesktopContent extends StatelessWidget {
  LeaderboardDesktopContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Center(
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //Left Column
          SizedBox(
              width: 320,
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Provider.of<ThemeProvider>(context)
                      .currentTheme
                      .colorScheme
                      .background,
                  child: Row(children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(
                          context), //will only work if home pushes when navigating to leaderboard
                    ),
                    Text("Leaderboard",
                        style:
                            TextStyle(fontSize: 40, color: Color(0xff72479d)))
                  ]),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 2,
                  height: 0,
                ),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.all(20),
                  color: Provider.of<ThemeProvider>(context)
                      .currentTheme
                      .colorScheme
                      .background,
                  child: ListView.separated(
                      separatorBuilder: (context, index) => Container(
                            height: 7,
                            color: Provider.of<ThemeProvider>(context)
                                .currentTheme
                                .colorScheme
                                .background,
                          ),
                      shrinkWrap: true,
                      itemCount: Provider.of<LeaderboardProvider>(context)
                          .publicCategories
                          .length,
                      itemBuilder: ((BuildContext context, int index) {
                        return CategoryTileDesktop(
                          title: Provider.of<LeaderboardProvider>(context)
                              .publicCategories[index],
                          entries: Provider.of<LeaderboardProvider>(context)
                              .publicCategories,
                        );
                      })),
                ))
                // ]),
              ])),
          VerticalDivider(
            color: Colors.grey,
            thickness: 2,
            width: 0,
          ),
          //Right Column
          Expanded(
            // child: Container(
            // padding: const EdgeInsets.all(20),
            child: Column(children: [
              Container(
                color: Color(0xff72479d),
                child: Row(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                            Provider.of<LeaderboardProvider>(context).category,
                            style:
                                TextStyle(fontSize: 40, color: Colors.white)))
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(20),
                      child: ListView.separated(
                          separatorBuilder: (context, index) => Container(
                                height: 7,
                              ),
                          shrinkWrap: true,
                          itemCount: Provider.of<LeaderboardProvider>(context)
                              .totalEntries,
                          itemBuilder: ((BuildContext context, int index) {
                            return UserTileDesktop(
                                index: index,
                                entries:
                                    Provider.of<LeaderboardProvider>(context)
                                        .entries);
                          }))))
            ]),
          )
          // )
        ])));
  }
}
