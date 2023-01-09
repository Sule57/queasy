import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:queasy/src/view/home_view.dart';
import 'package:queasy/src/view/statistics/statistics_provider.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../constants/theme_provider.dart';
import '../play_quiz/quiz_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        // backgroundColor: const Color(0xfff1ffe7),
        body: Center(
            child: Stack(children: [
      Container(
        constraints: const BoxConstraints(
            minWidth: double.infinity, maxWidth: double.infinity),
        height: 450,
      ),
      //light green rectangle at the bottom of the screen
      Column(
        children: [
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomLeft,
              child: Container(
                width: width,
                height: height / 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                  ),
                  color: const Color(0xfff1ffe7),
                ),
              ),
            ),
          )
        ],
      ),
      Center(
        child: Column(
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
                  Text(
                    'Statistics',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Provider.of<ThemeProvider>(context)
                          .currentTheme
                          .colorScheme
                          .background,
                      fontSize: 40,
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      width: 325,
                      height: 240,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Provider.of<ThemeProvider>(context)
                            .currentTheme
                            .colorScheme
                            .background,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  Provider.of<StatisticsProvider>(context)
                                          .correct
                                          .toString() +
                                      '\n Correct',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  Provider.of<QuizProvider>(context)
                                          .currentPoints
                                          .toString() +
                                      '\n Points',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  Provider.of<StatisticsProvider>(context)
                                          .secondsSpent
                                          .toString() +
                                      '\n Seconds',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          CircularPercentIndicator(
                              radius: 90,
                              lineWidth: 20,
                              percent: (Provider.of<StatisticsProvider>(context)
                                      .correct /
                                  10 *
                                  2),
                              progressColor: Color(0xff72479d),
                              center: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: const BoxDecoration(
                                      color: Color(0xfff1ffe7),
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          (Provider.of<StatisticsProvider>(
                                                              context)
                                                          .correct *
                                                      20)
                                                  .toString() +
                                              '%',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          'Correct',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  )))
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeView()),
                );
              },
              child: Text(
                'Continue',
                style: TextStyle(
                  color: Provider.of<ThemeProvider>(context)
                      .currentTheme
                      .colorScheme
                      .background,
                  fontSize: 40,
                ),
              ),
            ),
          ],
        ),
      )
    ])));
  }
}

class StatisticsDesktopContent extends StatelessWidget {
  StatisticsDesktopContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xfff1ffe7),
        appBar: AppBar(
          backgroundColor: const Color(0xff72479d),
          title: Center(
            child: Text('Statistics',
                style: TextStyle(
                    fontSize: 40,
                    color: Provider.of<ThemeProvider>(context)
                        .currentTheme
                        .colorScheme
                        .background)),
          ),
        ),
        body: Stack(children: <Widget>[
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Provider.of<ThemeProvider>(context)
                    .currentTheme
                    .colorScheme
                    .background,
              ),
              margin: const EdgeInsets.only(
                  left: 80.0, right: 80, top: 20, bottom: 65),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          Provider.of<StatisticsProvider>(context)
                                  .correct
                                  .toString() +
                              '\n Correct',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          Provider.of<QuizProvider>(context)
                                  .currentPoints
                                  .toString() +
                              '\n Points',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          Provider.of<StatisticsProvider>(context)
                                  .secondsSpent
                                  .toString() +
                              '\n Seconds',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: CircularPercentIndicator(
                        radius: 90,
                        lineWidth: 20,
                        percent:
                            (Provider.of<StatisticsProvider>(context).correct /
                                10 *
                                2),
                        progressColor: Color(0xff72479d),
                        center: Container(
                            width: 150,
                            height: 150,
                            decoration: const BoxDecoration(
                                color: Color(0xfff1ffe7),
                                shape: BoxShape.circle),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    (Provider.of<StatisticsProvider>(context)
                                                    .correct *
                                                20)
                                            .toString() +
                                        '%',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    'Correct',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ],
                              ),
                            ))),
                  )
                ],
              )),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
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
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeView()),
                  );
                },
                child: Text(
                  '          Continue           ',
                  style: TextStyle(
                    color: Provider.of<ThemeProvider>(context)
                        .currentTheme
                        .colorScheme
                        .background,
                    fontSize: 40,
                  ),
                ),
              ),
            ),
          ),
        ]));
  }
}
