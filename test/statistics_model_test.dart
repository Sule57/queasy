import 'dart:convert';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:queasy/src/model/profile.dart';
import 'package:queasy/src/model/statistics.dart';





void main() async {
  final instance = FakeFirebaseFirestore();
  Profile user_test = Profile.test(
      username: 'TEST21',
      email: 'email@test.com',
      hashPassword: 'nothashedpassword',
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