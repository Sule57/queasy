import 'dart:convert';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:queasy/src/model/statistics.dart';

//
// void main() async {
//   final instance = FakeFirebaseFirestore();
//   UserQuizzResults q1 = UserQuizzResults("quizz1", 50, 100, 300);
//   UserQuizzResults q2 = UserQuizzResults("quizz2", 1, 100, 300);
//   UserQuizzResults q3 = UserQuizzResults("quizz3", 50, 200, 300);
//   UserQuizzResults q5 = UserQuizzResults("quizz5", 50, 200, 300);
//   UserStatistics s = UserStatistics("statisticsTest", [q5]);
//   s.addQuizzStatistics(instance);
//   // final user_test = new Profile.test(
//   //     username: 'TEST21',
//   //     email: 'email@test.com',
//   //     hashPassword: 'nothashedpassword',
//   //     firestore: instance);
//   Map<String, dynamic> expectedDumpAfterset = {
//     'username': 'TEST21',
//     'lastName': '',
//     'firstName': '',
//     'hashPassword': 'nothashedpassword',
//     'bio': '',
//     'age': 0,
//     'scores': {},
//     'privateScore': {},
//   };
//
//   ///tests method register() in User model
//   test('Test statistics creation', () async {
//     UserStatistics s = UserStatistics("statisticsTest", [q5]);
//     usr.registerUser(instance);
//     Map<String, dynamic> data = json.decode(instance.dump());
//     expect(data['users']["TEST21"], equals(expectedDumpAfterset));
//   });