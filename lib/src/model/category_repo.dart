import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:queasy/src/model/category.dart';
import '../../utils/exceptions.dart';
import 'package:queasy/src/model/profile.dart';

/// Gathers all the categories available from the user in the variable
/// [categoryList]. The documents are retrieved from Firestore and stored in
/// [_publicDoc] for public categories and [_privateDoc] for categories
/// created by the user.
///
class CategoryRepo {
  // List<Category> categoryList = [];
  DocumentReference _publicDoc =
      FirebaseFirestore.instance.collection('categories').doc('public');
  DocumentReference _privateDoc = FirebaseFirestore.instance
      .collection('categories')
      .doc(getCurrentUserID());

  /// Creates a new [Category] in the database.
  ///
  /// [category] is the name of the [Category] and [color] is the color of the [Category].
  /// Checking if category already exists in the database is done before calling this function.
  Future<void> createCategory(String cat, Color color) async {
    String? id = await getCurrentUserID();
    String? username = await getCurrentUserUsername();
    print('id: $id, ' + 'username: $username');
    if (id == null || username == null) {
      throw UserNotLoggedInException();
    }
    await _privateDoc.update({
      cat: color.value,
    });

    await _privateDoc
        .collection(cat)
        .doc('question-1')
        .set({'ID': 'question-1'});
    await FirebaseFirestore.instance
        .collection('leaderboard')
        .doc(id + '-' + cat)
        .set({
      username: {'points': 0, 'position': 1}
    });
  }

  /// Deletes the current [Category] from the database.
  Future<void> deleteCategory(String _category) async {
    String? username = getCurrentUserID();
    if (username == null) {
      throw UserNotLoggedInException();
    }
    await _privateDoc.update({
      _category: FieldValue.delete(),
    });
    // iterate through all questions in the category and delete them
    await _privateDoc.collection(_category).get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  /// Gets the list of [String] names of current user's public [Category]s.
  Future<List<String>> getPublicCategories() async {
    String? username = getCurrentUserID();
    if (username == null) {
      throw UserNotLoggedInException();
    }
    List<String> list = [];
    // // parse through the document and update the positions
    await _publicDoc.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot != null && documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        for (String key in data.keys) {
          list.add(key);
        }
      }
    });
    return list;
  }

  /// Get the list of [String] names of current user's private [Category]s.
  Future<List<String>> getPrivateCategories() async {
    String? username = getCurrentUserID();
    if (username == null) {
      throw UserNotLoggedInException();
    }
    List<String> list = [];
    // get all document id from public categories
    await _privateDoc.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        for (String key in data.keys) {
          list.add(key);
        }
      }
    });
    return list;
  }
}
