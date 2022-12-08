import 'package:flutter/material.dart';
import 'package:queasy/src/view/statistic_view_controller.dart';

class StatisticsView extends StatelessWidget {
  StatisticsView({Key? key}) : super(key: key);
  final StatisticsViewController controller = StatisticsViewController();

  get correct => null;

  @override
  Widget build(BuildContext context) {
    if (controller.getCorrectAnswers() != null){
      final int correct = controller.getCorrectAnswers();
    }

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
                                        //controller.getCorrectAnswers();
                                        correct.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '0 \n Points',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '300 \n Seconds',
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
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(const Color(0xff72479d)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ))),
                    onPressed: () {},
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
