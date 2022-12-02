import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//const List<String> list = <String>['All', 'Art', 'Science', 'Sports'];

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
  /// [LeaderboardViewBackground] and the [LeaderboardViewContent] on top.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: const [
          // LeaderboardViewBackground(),
          LeaderboardViewContent(),
        ],
      ),
    );
  }
}

/// Background for [LeaderboardView].
///
/// Uses a [StatelessWidget] to display a background color.
class LeaderboardViewBackground extends StatelessWidget {
  /// Constructor for [LeaderboardViewBackground].
  const LeaderboardViewBackground({Key? key}) : super(key: key);

  /// Builds the background.
  ///
  /// It shows a container of size one third of the screen and with the main
  /// color of [AppThemes].
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Container(
      height: height / 3,
      width: double.infinity,
      color: Theme.of(context).colorScheme.onPrimary,
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: Image.asset(
          "lib/assets/images/logo_horizontal.png",
          height: 50,
        ),
      ),
    );
  }
}

/// Content for [QuizView].
///
/// Uses a [StatefulWidget] to display questions and answers and update the
/// text contained in the widgets.
class LeaderboardViewContent extends StatefulWidget {
  const LeaderboardViewContent({Key? key}) : super(key: key);

  /// Creates a [QuizViewContent] state.
  @override
  State<LeaderboardViewContent> createState() => _LeaderboardViewContentState();
}

/// State for [QuizViewContent].
class _LeaderboardViewContentState extends State<LeaderboardViewContent> {
  /// Builds the content.
  ///
  /// It uses a [Column] to display the different elements of the view:
  /// [categoryTitle], [scoreTracking], [questionContainer] and [answerButtons].
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('leaderboard').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return width < 700
              ? const LeaderboardMobileContent()
              : const LeaderboardDesktopContent();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class LeaderboardMobileContent extends StatelessWidget {
  const LeaderboardMobileContent({Key? key}) : super(key: key);

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
                        subtitle: index == 0
                            ? const Text(
                                'points',
                                textAlign: TextAlign.center,
                              )
                            : const Text(
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

class LeaderboardDesktopContent extends StatelessWidget {
  const LeaderboardDesktopContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Stack(children: [
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
                        subtitle: index == 0
                            ? const Text(
                                'points',
                                textAlign: TextAlign.center,
                              )
                            : const Text(
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
