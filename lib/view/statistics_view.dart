import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:queasy/view/widgets/custom_bottom_nav_bar.dart';

import 'home_view.dart';
//import 'package:queasy/view/widgets/custom_bottom_nav_bar.dart';

class StatisticsView extends StatelessWidget {
  const StatisticsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const CustomBottomNavBar(pageTitle: 'Quiz View'),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: Center(
            child: Stack(children: [
              //set part of the background to white
              Container(
                color: Colors.white,
                constraints: const BoxConstraints(
                    minWidth: double.infinity, maxWidth: double.infinity),
                height: 450,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //Add owl image at the top of the screen
                  const Image(image: AssetImage('lib/assets/images/owl.png')),
                  //Displays statistics of player after he played the quiz. Is filled with test examples right now.
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    width: 350,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Statistics',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontFamily: GoogleFonts.nunito().fontFamily,
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
                                  children: const <Widget>[
                                    Expanded(
                                      //shows how many questions the player did correctly (example data)
                                      child: Text(
                                        '0 \n Correct',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        //shows how many points he got for the quiz (example data)
                                        '0 \n Points',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        //shows how much time the player took to complete the quiz (example data)
                                        '300 \n Seconds',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                //Displays result in percentage (example data)
                                Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                        shape: BoxShape.circle),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: const [
                                          Text(
                                            '0%',
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
                  //Button "Continue" to go to HomeView
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ))),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HomeView(),
                      ));
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
