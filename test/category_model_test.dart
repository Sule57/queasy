import 'dart:ui';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:queasy/src/model/category.dart';
import 'package:queasy/src/model/category_repo.dart';
import 'package:queasy/src/model/quiz.dart';

/// Main function for testing the [Category] class.
///
/// [instance] is the Fake Firestore instance for mocking of the database
void main() async {
  String catName = 'German';
  Color color = Color(12423);
  String UID = 'uid1';
  String username = 'Savo';

  var instance = FakeFirebaseFirestore();

  await instance.collection('categories').doc('public').set({});
  await instance.collection('categories').doc(UID).set({});


  await CategoryRepo(instance_: instance, id: UID).createCategory(catName, color, instance: instance, uid: UID, username_: username);

  Category cat = await Category(name: catName, color:color, firestore:instance, UID: UID);
  test('Category is not created properly', () {
    expect({cat.getName(), cat.getColor(), cat.UID}, {catName, color, UID});
  });


  test('Category color is not set properly', () async {
    Color newColor = Color(123);
    await cat.setColor(newColor);

    cat = await CategoryRepo(instance_: instance, id: UID).getCategory(catName, instance: instance, uid: UID, username_: username);
    expect(cat.getColor(), newColor);
  });


  test('Category name is not set properly', () async {
    String newName = 'English';

    await cat.changeNameOfCategory(newName);
    cat = await CategoryRepo(instance_: instance, id: UID).getCategory(newName, instance: instance, uid: UID, username_: username);

    expect(cat.getName(), newName);
  });

  // CategoryRepo().getCategory(catName);


}
