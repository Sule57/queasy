import 'dart:convert';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:queasy/model/user.dart';

/// Main function for testing the [Profile] class.
void main() async {
  final instance = FakeFirebaseFirestore();
  final profile_test = Profile.test(
      username: 'profileTest',
      hashPassword: 'profileTest',
      firestore: instance);
  Map<String, dynamic> expectedDataAfterUpdates = {
    "testProfileDocID": {
      'username': 'testProfile',
      'firstName': 'profile',
      'lastName': 'test',
      'profilePicture': 'profile.png',
      'bio': 'This is the test for the profile class.',
      'birthdayMonth': 'Jancember',
      'birthdayDay': 124,
    }
  };

  /// Creates testProfile information for testing
  Map<String, String> testProfile = {
    'username': 'profileTest',
  };

  /// Pushes testProfile into the fake firestore database
  await instance.collection('users').doc("testProfileDocID").set(testProfile);

  /// Testing update username in profile class
  test('Profile should have changed username', () {
    expect(
        profile_test.updateUsername(
            "testProfileDocID", 'testProfile', instance),
        true);
  });

  /// Testing update name in profile class
  test('Profile should have changed first and last name', () {
    expect(
        profile_test.updateName(
            "testProfileDocID", 'profile', 'test', instance),
        true);
  });

  /// Testing update picture in profile class
  test('Profile should have changed picture', () {
    expect(
        profile_test.updatePicture("testProfileDocID", 'profile.png', instance),
        true);
  });

  /// Testing update bio in profile class
  test('Profile should have changed bio', () {
    expect(
        profile_test.updateBio("testProfileDocID",
            'This is the test for the profile class.', instance),
        true);
  });

  /// Testing update birthday in profile class
  test('Profile should have changed birthday month and day', () {
    expect(
        profile_test.updateBirthday(
            "testProfileDocID", 'Jancember', 124, instance),
        true);
  });

  /// Testing after all updates that profile information is correct
  test('Profile should match Expected Data', () {
    Map<String, dynamic> data = json.decode(instance.dump());
    expect(data['users'], equals(expectedDataAfterUpdates));
  });
}
