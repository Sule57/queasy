import 'dart:ui';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:queasy/src.dart';
import 'package:queasy/src/model/category.dart';
import 'package:queasy/src/model/category_repo.dart';
import 'package:queasy/src/model/quiz.dart';

/// Main function for testing the [CategoryRepo] class.
///
/// [instance] is the Fake Firestore instance for mocking of the database
///
/// [catName] and respected variables are the names of the category
///
/// [UID] is the UID of the user
///
/// [color] is the color of the category
///
/// [username] is the username of the user
void main() async {
  String catName1 = 'German1';
  String catName2 = 'German2';
  String catName3 = 'German3';

  Color color = Color(12423);
  String UID = 'uid1';
  String username = 'Savo';

  var instance = FakeFirebaseFirestore();

  await instance.collection('categories').doc('public').set({});
  await instance.collection('categories').doc(UID).set({});


  Category cat1 = await Category(name: catName1, color:color, firestore:instance, UID: UID);
  Category cat2 = await Category(name: catName2, color:color, firestore:instance, UID: UID);
  Category cat3 = await Category(name: catName3, color:color, firestore:instance, UID: UID);

  await CategoryRepo(instance_: instance, id: UID).createCategory(catName1, color, instance: instance, uid: UID, username_: username);
  await CategoryRepo(instance_: instance, id: UID).createCategory(catName2, color, instance: instance, uid: UID, username_: username);
  await CategoryRepo(instance_: instance, id: UID).createCategory(catName3, color, instance: instance, uid: UID, username_: username);



  test('Categories are not retrieved successfully', () async {
    List<String> list = await CategoryRepo(instance_: instance, id: UID).getPrivateCategories(instance: instance, uid: UID, username_: username);
    expect(list.length, 3);
  });

  test('Category is not deleted successfully', () async {
    await CategoryRepo(instance_: instance, id: UID).deleteCategory(catName1, instance: instance, uid: UID, username_: username);
    List<String> list = await CategoryRepo(instance_: instance, id: UID).getPrivateCategories(instance: instance, uid: UID, username_: username);

    expect(list.length, 2);
  });



}
