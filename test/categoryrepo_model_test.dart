import 'dart:ui';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:queasy/src.dart';
import 'package:queasy/src/model/category.dart';
import 'package:queasy/src/model/category_repo.dart';
import 'package:queasy/src/model/quiz.dart';

/// Main function for testing the [CategoryRepo] class.
void main() async {
  /// Names of the category
  String catName1 = 'German1';
  String catName2 = 'German2';
  String catName3 = 'German3';

  /// Color of the category
  Color color = Color(12423);

  /// UID of the user
  String UID = 'uid1';

  /// Username of the user
  String username = 'Savo';

  /// Fake Firestore instance for mocking of the database
  var instance = FakeFirebaseFirestore();
  await instance.collection('categories').doc(UID).set({});
  await instance.collection('categories').doc('public').set({});

  /// Test if the categories are retrieved from the database
  test('Public categories are not retrieved successfully', () async {
    await instance.collection('categories').doc('public').collection('Arts').doc('question-1').set({'ID': 'question-1'});
    await instance.collection('categories').doc('public').update({'Arts': color.value});

    await instance.collection('categories').doc('public').collection('Sports').doc('question-1').set({'ID': 'question-1'});
    await instance.collection('categories').doc('public').update({'Sports': color.value + 1});
    List<String> list = await CategoryRepo(instance_: instance, id: UID).getPublicCategories(instance: instance, uid: UID, username_: username);
    expect(list.length, 2);
  });

  /// Test if the category is created successfully
  test('Private categories are not created successfully', () async {
    await CategoryRepo(instance_: instance, id: UID).createCategory(catName1, color, instance: instance, uid: UID);
    await CategoryRepo(instance_: instance, id: UID).createCategory(catName2, color, instance: instance, uid: UID);
    await CategoryRepo(instance_: instance, id: UID).createCategory(catName3, color, instance: instance, uid: UID);

    List<String> list = await CategoryRepo(instance_: instance, id: UID).getPrivateCategories(instance: instance, uid: UID, username_: username);
    expect(list.length, 3);
  });

  /// Test if the private categories are retrieved from the database
  test('Private categories are not retrieved successfully', () async {
    List<String> list = await CategoryRepo(instance_: instance, id: UID).getPrivateCategories(instance: instance, uid: UID, username_: username);
    expect(list.length, 3);
  });

  /// Test if the category is deleted
  test('Category is not deleted successfully', () async {
    await CategoryRepo(instance_: instance, id: UID).deleteCategory(catName1, instance: instance, uid: UID);

    List<String> list = await CategoryRepo(instance_: instance, id: UID).getPrivateCategories(instance: instance, uid: UID, username_: username);

    expect(list.length, 2);
  });
}
