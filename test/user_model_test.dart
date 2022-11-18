

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'package:queasy/model/user.dart';
import 'dart:convert';
import 'package:test/test.dart';

void main() {
    final instance = FakeFirebaseFirestore();
    final user_test = new User.test(username: 'TEST21',hashPassword: 'nothashedpassword', firestore: instance);
    Map<String, dynamic> expectedDumpAfterset = {
      "TEST21": {
        'lastName': '',
        'firstName': '',
        'hashPassword' : 'nothashedpassword',
        'bio': '',
        'age': 0,
        'scores': {},
        'privateScore': {},
      }
    };
    ///tests method register() in User model
    test ('Test user registration', () async {
      final usr = new User.test(username: 'TEST21',hashPassword: 'nothashedpassword', firestore: instance);
      usr.registerUser(instance);
      Map<String, dynamic> data = json.decode(instance.dump());
      expect(data['users'], equals(expectedDumpAfterset));
    });
    /// tests User instance creation from json file
    test ('Test fromJsonConstructor', () async {
      final usr = new User.test(username: 'TEST21',hashPassword: 'nothashedpassword', firestore: instance);
      usr.registerUser(instance);
      Map<String, dynamic> data = json.decode(instance.dump());


      final r_user = User.fromJson(data['users']);
      print(r_user.toString());
      expect(r_user.toString(), equals(user_test.toString()));
    });
}

