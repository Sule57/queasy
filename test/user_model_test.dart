import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:queasy/src.dart';
import 'package:queasy/src/model/profile.dart';
import 'package:queasy/utils/exceptions.dart';
// import 'package:test/test.dart';

String uid = "mockedyouu";

/// mock register so you avoid using firebase auth in tests
Future<bool> mockRegister(Profile p) async {

  await p
      .firestore
      .collection('users')
      .doc(uid)
      .get();
    //   .then((DocumentSnapshot documentSnapshot) {
    // if (documentSnapshot.exists) {
    // print(p.firestore
    //     .collection('users')
    //     .doc(uid)
    //     .get().toString());
    //  // print(documentSnapshot);
    //   throw UserAlreadyExistsException();
    // }
  //});

  if (uid != null) {
    // create the document for categories created by the user
    await p.firestore.collection('categories').doc(uid).set({});

    await p.firestore
        .collection('users')
        .doc(uid)
        .set(p.toJson());
    UserStatistics s = UserStatistics(p.username, []);
    //Adding the user to the statistics
    Map<String, dynamic> data = {};
    await p.firestore.collection('UserStatistics').doc(p.username).set(data);
    return true;
  }

  return false;
}


/// Main function for testing the [Profile] class.
void main() async {

  final instance = FakeFirebaseFirestore();

  Profile user_test = Profile.test(
      username: 'TEST21',
      email: 'email@test.com',
      firestore: instance);
  Map<String, dynamic> expectedDumpAfterset = {
    'username': 'TEST21',
    'lastName': '',
    'firstName': '',
    'email': 'email@test.com',
    'bio': '',
    'age': 0,
    'scores': {},
    'privateScore': {},
  };

  ///tests method register() in User model
  test('Test user registration', () async {
    Profile usr = Profile.test(
        username: 'TEST21',
        email: 'email@test.com',
        firestore: instance);
    await mockRegister(usr);
    //Map<String, dynamic> data = await instance.collection('users').get() as Map<String, dynamic>;
    Map<String, dynamic> data = jsonDecode(instance.dump())['users'][uid];
    expect(data, equals(expectedDumpAfterset));
  });

  /// tests User instance creation from json file
  //TODO UPDATE TESTS WITH THE VALIDATION AND EXCEPTIONS
  test('Test fromJsonConstructor', () async {
    final usr = new Profile.test(
        username: 'TEST21',
        email: 'email@test.com',
        firestore: instance);
    await mockRegister(usr);
    //Map<String, dynamic> data = await instance.collection('users').get() as Map<String, dynamic>;
    Map<String, dynamic> data = jsonDecode(instance.dump())['users'][uid];
    final r_user = Profile.fromJson(data);
    print(r_user.toString());
    expect(r_user.toString(), equals(user_test.toString()));
  });

  //it cannot work
  // test('Test data validation', () async {
  //   Profile usr = new Profile.test(
  //       username: 'TEST21',
  //       email: 'email@test.com',
  //       firestore: instance);
  //   //Map<String, dynamic> data = await instance.collection('users').get() as Map<String, dynamic>;
  //
  //   // a UserAlreadyExists exception is expected
  //   expect(usr.registerUser(), throwsA(isA<UserAlreadyExistsException>()));
  // });

  ///Tests for Profile Class methods that update database information
  final profile_test = Profile.test(
      username: 'profileTest',
      email: 'profileEmail@test.com',
      firestore: instance);
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
  await mockRegister(profile_test);
  // await instance.collection('users').doc("testProfileDocID").set(testProfile);

  /// Testing update username in profile class
  test('Profile should have changed username', () {
    expect(profile_test.updateUsername('testProfile'), true);
  });

  /// Testing update name in profile class
  test('Profile should have changed first and last name', () {
    expect(profile_test.updateName('profile', 'test'), true);
  });

  /// Testing update picture in profile class
  test('Profile should have changed picture', () {
    expect(profile_test.updatePicture('profile.png'), true);
  });

  /// Testing update bio in profile class
  test('Profile should have changed bio', () {
    expect(profile_test.updateBio('This is the test for the profile class.'),
        true);
  });

  /// Testing update birthday in profile class
  test('Profile should have changed birthday month and day', () {
    expect(profile_test.updateBirthday('Jancember', 124), true);
  });

  /// Testing after all updates that profile information is correct
  // test('Profile should match Expected Data', () {
  //   Map<String, dynamic> data = json.decode(instance.dump());
  //   expect(data['users']["testProfileDocID"], equals(expectedDataAfterUpdates));
  // });
}
