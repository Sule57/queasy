import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:queasy/src/view/home_view.dart';
import 'package:queasy/src/view/statistics/statistic_view_controller.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({Key? key}) : super(key: key);

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

/// State for [StatisticsView].
class _StatisticsViewState extends State<StatisticsView> {
  /// Builds the view.
  ///
  /// Uses a [Stack] to display the
  /// [StatisticsDesktopViewBackground] and the [StatisticsViewContent] on top.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: const [
          StatisticsDesktopViewBackground(),
          StatisticsViewContent(),
        ],
      ),
    );
  }
}

/// Background for [StatisticsView].
///
/// Uses a [StatelessWidget] to display a background color.
class StatisticsDesktopViewBackground extends StatelessWidget {
  /// Constructor for [LeaderboardDesktopViewBackground].
  const StatisticsDesktopViewBackground({Key? key}) : super(key: key);

  /// Builds the background.
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return width > 700
        ? Scaffold(
        backgroundColor: Color(0xfff1ffe7),
        )
        : Container(); //empty container for mobile view
  }
}

/// Content for [StatisticsView].
///
/// Uses a [StatefulWidget] to display statistics and updates the
/// text contained in the widgets.
class StatisticsViewContent extends StatefulWidget {
  const StatisticsViewContent({Key? key}) : super(key: key);

  /// Creates a [StatisticsViewContent] state.
  @override
  State<StatisticsViewContent> createState() => _StatisticsViewContentState();
}

/// State for [StatisticsViewContent].
class _StatisticsViewContentState extends State<StatisticsViewContent> {
  /// Builds the content.
  ///
  /// It uses a [Scaffold] to display the different elements of the view:
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('leaderboard').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return width < 700
              ? StatisticsMobileContent()
              : StatisticsDesktopContent();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}





class StatisticsMobileContent extends StatelessWidget {
  StatisticsMobileContent({Key? key}) : super(key: key);
  final StatisticsViewController controller = StatisticsViewController();

  @override
  Widget build(BuildContext context) {

    final int correct = controller.getCorrectAnswers();
    final double points = controller.getPoints();
    final double secondsSpent = controller.getSecondsSpent();
    final int correctPercentage = controller.getCorrectPercentage();

    return Scaffold(
      
        backgroundColor: const Color(0xfff1ffe7),
        body: Center(
            child: Stack(children: [
              Container(
                color: Colors.white,
                constraints: const BoxConstraints(
                    minWidth: double.infinity, maxWidth: double.infinity),
                height: 450,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Image(image: AssetImage('lib/assets/images/logo.png')),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    width: 350,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xff72479d),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Statistics',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            width: 325,
                            height: 240,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        correct.toString() + '\n Correct',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        points.toString() + '\n Points',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        secondsSpent.toString() + '\n Seconds',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                    width: 150,
                                    height: 150,
                                    decoration: const BoxDecoration(
                                        color: Color(0xfff1ffe7),
                                        shape: BoxShape.circle),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            correctPercentage.toString()+'%',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                          Text(
                                            'Correct',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                              ],
                            )),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(const Color(0xff72479d)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ))),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeView()),
                      );
                    },
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ])));
  }
}

class StatisticsDesktopContent extends StatelessWidget {
  StatisticsDesktopContent({Key? key}) : super(key: key);
  final StatisticsViewController controller = StatisticsViewController();

  @override
  Widget build(BuildContext context) {

    final int correct = controller.getCorrectAnswers();
    final double points = controller.getPoints();
    final double secondsSpent = controller.getSecondsSpent();
    final int correctPercentage = controller.getCorrectPercentage();

    return Scaffold(
        backgroundColor: const Color(0xfff1ffe7),
        appBar: AppBar(
          backgroundColor: const Color(0xff72479d),
          title: const Center(
            child: Text('Statistics',
                style: TextStyle(fontSize: 40, color: Colors.white)),
          ),
        ),
        body: Stack(children: <Widget>[
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              margin:
              const EdgeInsets.only(left: 80.0, right: 80, top: 20, bottom: 65),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          correct.toString() +
                          '\n Correct',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          points.toString() +
                          '\n Points',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          secondsSpent.toString() +
                          '\n Seconds',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                          color: Color(0xfff1ffe7), shape: BoxShape.circle),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              correctPercentage.toString()+
                              '%',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                            Text(
                              'Correct',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ))

                ],
              )),
          Container(
            margin:
            const EdgeInsets.symmetric(vertical: 10),
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(const Color(0xff72479d)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ))),
                onPressed: () {
                  //Navigator.push(
                  //  context,
                  //  MaterialPageRoute(builder: (context) => const HomeView()),
                  //);
                },
                child: const Text(
                  '          Continue           ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                  ),
                ),
              ),
            ),
          ),
        ]));
  }
}