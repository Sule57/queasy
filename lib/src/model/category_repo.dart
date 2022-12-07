import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:queasy/src/model/category.dart';

class CategoryRepo {
  List<Category> categoryList = [];

  /// Collection [DocumentReference] for the public [Category] location in the database.
  DocumentReference _publicDoc =
      FirebaseFirestore.instance.collection('categories').doc('public');

  /// Collection [DocumentReference] for the private [Category] location in the database.
  DocumentReference _privateDoc = FirebaseFirestore.instance
      .collection('categories')
      .doc(getCurrentUserID());

  /// Creates a new [Category] in the database.
  ///
  /// [category] is the name of the [Category] and [color] is the color of the [Category].
  /// Checking if category already exists in the database is done before calling this function.
  Future<void> createCategory(String cat, Color color) async {
    String? username = getCurrentUserID();
    if (username == null) {
      throw Exception('User is not logged in');
    }
    await _privateDoc.set({
      cat: color.value,
    });

    // iterate through all questions in the category and delete them
    await _privateDoc.collection(cat).get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
    await _privateDoc.collection(cat).doc('firstQuestion').set({});
  }

  /// Deletes the current [Category] from the database.
  Future<void> deleteCategory(String _category) async {
    String? username = getCurrentUserID();
    if (username == null) {
      throw Exception('User is not logged in');
    }
    await _privateDoc.update({
      _category: FieldValue.delete(),
    });
  }

  /// Gets the list of [String] names of current user's public [Category]s.
  Future<List<String>> getPublicCategories() async {
    String? username = getCurrentUserID();
    if (username == null) {
      throw Exception('User is not logged in');
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
      throw Exception('User is not logged in');
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
