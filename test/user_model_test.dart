import 'dart:convert';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:queasy/src/model/profile.dart';
// import 'package:test/test.dart';

/// Main function for testing the [Profile] class.
void main() async {
  final instance = FakeFirebaseFirestore();
  Profile user_test = Profile(
      username: 'TEST21',
      email: 'email@test.com',
      hashPassword: 'nothashedpassword',);
  Map<String, dynamic> expectedDumpAfterset = {
    'username': 'TEST21',
    'lastName': '',
    'firstName': '',
    'email': 'email@test.com',
    'hashPassword': 'nothashedpassword',
    'bio': '',
    'age': 0,
    'scores': {},
    'privateScore': {},
  };

  ///tests method register() in User model
  test('Test user registration', () async {
    final usr = new Profile(
        username: 'TEST21',
        email: 'email@test.com',
        hashPassword: 'nothashedpassword');
    await usr.registerUser(instance);
    //Map<String, dynamic> data = await instance.collection('users').get(). as Map<String, dynamic>;
    Map<String, dynamic> data = jsonDecode(instance.dump())['users'];
    expect(data["TEST21"], equals(expectedDumpAfterset));
  });

  /// tests User instance creation from json file
  //TODO UPDATE TESTS WITH THE VALIDATION AND EXCEPTIONS
  test('Test fromJsonConstructor', () async {
    final usr = new Profile(
        username: 'TEST21',
        email: 'email@test.com',
        hashPassword: 'nothashedpassword',);
    //Map<String, dynamic> data = await instance.collection('users').get() as Map<String, dynamic>;
    Map<String, dynamic> data = jsonDecode(instance.dump())['users'];
    final r_user = Profile.fromJson(data["TEST21"]);
    print(r_user.toString());
    expect(r_user.toString(), equals(user_test.toString()));
  });

  ///Tests for Profile Class methods that update database information
  final profile_test = Profile(
      username: 'profileTest',
      email: 'profileEmail@test.com',
      hashPassword: 'profileTest');
  Map<String, dynamic> expectedDataAfterUpdates = {
    'username': 'testProfile',
    'firstName': 'profile',
    'lastName': 'test',
    'profilePicture': 'profile.png',
    'bio': 'This is the test for the profile class.',
    'birthdayMonth': 'Jancember',
    'birthdayDay': 124,
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
    expect(data['users']["testProfileDocID"], equals(expectedDataAfterUpdates));
  });
}
