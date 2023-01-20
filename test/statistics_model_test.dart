import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:queasy/src/model/profile.dart';
import 'package:queasy/src/model/statistics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:queasy/utils/exceptions.dart';

/// mock register so you avoid using firebase auth in tests
Future<bool> mockRegister(Profile p) async {
  String uid = "mockedyou";
  await p.firestore
      .collection('users')
      .doc(uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      throw UserAlreadyExistsException();
    }
  });

  if (uid != null) {
    // create the document for categories created by the user
    await p.firestore.collection('categories').doc(uid).set({});

    await p.firestore.collection('users').doc(uid).set(p.toJson());
    UserStatistics s = UserStatistics(p.username, []);
    //Adding the user to the statistics
    Map<String, dynamic> data = {};
    await p.firestore.collection('UserStatistics').doc(p.username).set(data);
    return true;
  }

  return false;
}

void main() async {
  final instance = FakeFirebaseFirestore();

  Profile user_test = Profile.test(
      username: 'TEST21', email: 'email@test.com', firestore: instance);
  // it is assumed that registerUser is working properly
  await mockRegister(user_test);

  Map<String, dynamic> expectedDumpAfterset = {
    "quizz1": {"all": 100, "correct": 50, "timeSpent": 300},
    "quizz2": {"all": 100, "correct": 1, "timeSpent": 300},
    "quizz3": {"all": 200, "correct": 50, "timeSpent": 300},
    "quizz5": {"all": 200, "correct": 50, "timeSpent": 300},
  };
  Map<String, dynamic> expectedDumpAftersetStprage = {
    "quizz1": {"all": 100, "correct": 50, "timeSpent": 300},
  };

  ///tests method register() in User model
  test('Test statistics storage adding 1 by 1', () async {
    UserQuizResult q1 = UserQuizResult("quizz1", 50, 100, 300);
    UserQuizResult q2 = UserQuizResult("quizz2", 1, 100, 300);
    UserQuizResult q3 = UserQuizResult("quizz3", 50, 200, 300);
    UserQuizResult q5 = UserQuizResult("quizz5", 50, 200, 300);
    List<UserQuizResult> l = [];
    l.add(q1);

    UserStatistics s = UserStatistics.test("TEST21", l, instance);
    await s.saveStatistics();
    Map<String, dynamic> data =
        jsonDecode(instance.dump())['UserStatistics'][user_test.username];
    expect(s.toJson(), equals(expectedDumpAftersetStprage));
  });

  ///tests method register() in User model
  test('Test statistics storage', () async {
    UserQuizResult q1 = UserQuizResult("quizz1", 50, 100, 300);
    UserQuizResult q2 = UserQuizResult("quizz2", 1, 100, 300);
    UserQuizResult q3 = UserQuizResult("quizz3", 50, 200, 300);
    UserQuizResult q5 = UserQuizResult("quizz5", 50, 200, 300);
    List<UserQuizResult> l = [];
    l.add(q1);
    l.add(q2);
    l.add(q3);
    l.add(q5);
    UserStatistics s = UserStatistics.test("TEST21", l, instance);
    await s.saveStatistics();
    Map<String, dynamic> data =
        jsonDecode(instance.dump())['UserStatistics'][user_test.username];
    expect(s.toJson(), equals(expectedDumpAfterset));
  });
}
