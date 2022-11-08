import 'package:flutter/cupertino.dart';
import 'package:queasy/model/quiz.dart';
import 'package:test/test.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // try {
  //   await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //       apiKey: 'AIzaSyCNGjdJ0j86h8b_Bk7d9ts-hY4JZ7aNWcQ',
  //       appId: 'quizzapp-eb0f2',
  //       messagingSenderId: '1:17686953226:web:81a053f17c2b317edd0ef3',
  //       projectId: '17686953226',
  //     ),
  //   );
  //   runApp(MyApp());
  // } catch (e) {
  //   print(e.toString());
  //   await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //       apiKey: 'AIzaSyCNGjdJ0j86h8b_Bk7d9ts-hY4JZ7aNWcQ',
  //       appId: 'quizzapp-eb0f2',
  //       messagingSenderId: '1:17686953226:web:81a053f17c2b317edd0ef3',
  //       projectId: '17686953226',
  //     ),
  //     name: 'qeasy_web_app',
  //   );
  //   runApp(MyApp());
  // }
  late Quiz quiz;
  test ('Check if quiz initialize works, and call the getter for the questions', () async {
    // List<Question> _questions = [];
    // quiz = Quiz(id: 1, noOfQuestions: 5, category: 'Science');
    // _questions = quiz.getQuestions();
    // expect(_questions.length, 5);
    // expect(_questions[0].answers.length, 4);
  });

}