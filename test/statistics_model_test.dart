import 'dart:convert';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:queasy/src/model/profile.dart';
import 'package:queasy/src/model/statistics.dart';
import 'package:firebase_core/firebase_core.dart';





void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final instance = FakeFirebaseFirestore();
  await Firebase.initializeApp(
    name: 'quizzapp-eb0f2',
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCNGjdJ0j86h8b_Bk7d9ts-hY4JZ7aNWcQ',
      appId: '1:17686953226:web:81a053f17c2b317edd0ef3',
      messagingSenderId: '17686953226',
      projectId: 'quizzapp-eb0f2',
      authDomain: 'quizzapp-eb0f2.firebaseapp.com',
      databaseURL:
      'https://quizzapp-eb0f2-default-rtdb.europe-west1.firebasedatabase.app',
      storageBucket: 'gs://quizzapp-eb0f2.appspot.com',
      measurementId: 'G-MSF5DXS9QN',
    ),
  );
  Profile user_test = Profile.test(
      username: 'TEST21',
      email: 'email@test.com',
      firestore: instance);
  // it is assumed that registerUser is working properly
  await user_test.registerUser();

  Map<String, dynamic> expectedDumpAfterset = {
    "quizz1": {
      "all": 100,
      "correct": 50,
      "timeSpent": 300
    },
    "quizz2": {
      "all": 100,
      "correct": 1,
      "timeSpent": 300
    },
    "quizz3": {
      "all": 200,
      "correct": 50,
      "timeSpent": 300
    },
    "quizz5": {
      "all": 200,
      "correct": 50,
      "timeSpent": 300
    },

  };
  Map<String, dynamic> expectedDumpAftersetStprage = {
    "quizz1": {
      "all": 100,
      "correct": 50,
      "timeSpent": 300
    },


  };

  ///tests method register() in User model
  test('Test statistics storage adding 1 by 1', () async {
    UserQuizzResult q1 = UserQuizzResult("quizz1", 50, 100, 300);
    UserQuizzResult q2 = UserQuizzResult("quizz2", 1, 100, 300);
    UserQuizzResult q3 = UserQuizzResult("quizz3", 50, 200, 300);
    UserQuizzResult q5 = UserQuizzResult("quizz5", 50, 200, 300);
    List<UserQuizzResult> l = [];
    l.add(q1);

    UserStatistics s = UserStatistics.test("TEST21", l, instance);
    await s.saveStatistics();
    Map<String, dynamic> data = jsonDecode(instance.dump())['UserStatistics'][user_test.username];
    expect(s.toJson(), equals(expectedDumpAftersetStprage));
  });




  ///tests method register() in User model
  test('Test statistics storage', () async {
    UserQuizzResult q1 = UserQuizzResult("quizz1", 50, 100, 300);
    UserQuizzResult q2 = UserQuizzResult("quizz2", 1, 100, 300);
    UserQuizzResult q3 = UserQuizzResult("quizz3", 50, 200, 300);
    UserQuizzResult q5 = UserQuizzResult("quizz5", 50, 200, 300);
    List<UserQuizzResult> l = [];
    l.add(q1);
    l.add(q2);
    l.add(q3);
    l.add(q5);
    UserStatistics s = UserStatistics.test("TEST21", l, instance);
    await s.saveStatistics();
    Map<String, dynamic> data = jsonDecode(instance.dump())['UserStatistics'][user_test.username];
    expect(s.toJson(), equals(expectedDumpAfterset));
  });
}