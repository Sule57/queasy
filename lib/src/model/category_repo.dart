import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:queasy/src.dart';
import 'package:queasy/src/model/category.dart';
import '../../utils/exceptions.dart';
import 'package:queasy/src/model/profile.dart';

/// Gathers all the categories available from the user in the variable
/// [_publicDoc] for public categories and [_privateDoc] for categories
/// created by the user.
///
class CategoryRepo {
  late DocumentReference _publicDoc;
  late DocumentReference _privateDoc;

  String? UID;

  /// Constructor
  CategoryRepo({FirebaseFirestore? instance_, String? id}){
    if(instance_ != null){
      this._publicDoc = instance_.collection('categories').doc('public');
      this._privateDoc = instance_.collection('categories').doc(id);
    }else{
      _publicDoc = FirebaseFirestore.instance.collection('categories').doc('public');
      _privateDoc = FirebaseFirestore.instance.collection('categories').doc(getCurrentUserID());
    }
  }

  /// Creates a new [Category] in the database.
  ///
  /// [categoryName] is the name of the [Category] and [color] is the color of the [Category].
  /// Checking if category already exists in the database is done before calling this function.
  Future<void> createCategory(String categoryName, Color color, {FirebaseFirestore? instance, String? uid, String? username_}) async {
    String? id;
    String? username;
    if(instance != null){
      if(uid == null || username_ == null) throw Exception("uid or username_ is null!");
      id = uid;
      username = username_;
      _publicDoc = instance.collection('categories').doc('public');
      _privateDoc = instance.collection('categories').doc(id);
    }else{
      id = await getCurrentUserID();
      username = await getCurrentUserUsername();
    }

    if (id == null || username == null) {
      throw UserNotLoggedInException();
    }
    await _privateDoc.update({
      categoryName: color.value,
    });

    await _privateDoc
        .collection(categoryName)
        .doc('question-1')
        .set({'ID': 'question-1'});

    if(instance == null) {
      await FirebaseFirestore.instance
          .collection('leaderboard')
          .doc(id + '-' + categoryName)
          .set({
        username: {'points': 0, 'position': 1}
      });
    }else{
      await instance
          .collection('leaderboard')
          .doc(id + '-' + categoryName)
          .set({
        username: {'points': 0, 'position': 1}
      });
    }
  }

  /// Deletes the current [Category] from the database.
  Future<void> deleteCategory(String _category, {FirebaseFirestore? instance, String? uid, String? username_}) async {
    String? id;
    String? username;
    if(instance != null){
      if(uid == null || username_ == null) throw Exception("uid or username_ is null!");
      id = uid;
      username = username_;
      _publicDoc = instance.collection('categories').doc('public');
      _privateDoc = instance.collection('categories').doc(id);
    }else{
      id = await getCurrentUserID();
      username = await getCurrentUserUsername();
    }

    print('id: $id, ' + 'username: $username');

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
  Future<List<String>> getPublicCategories({FirebaseFirestore? instance, String? uid, String? username_}) async {
    String? id;
    String? username;
    if(instance != null){
      if(uid == null || username_ == null) throw Exception("uid or username_ is null!");
      id = uid;
      username = username_;
      _publicDoc = instance.collection('categories').doc('public');
      _privateDoc = instance.collection('categories').doc(id);
    }else{
      id = await getCurrentUserID();
      username = await getCurrentUserUsername();
    }

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
  Future<List<String>> getPrivateCategories({FirebaseFirestore? instance, String? uid, String? username_}) async {
    String? id;
    String? username;
    if(instance != null){
      if(uid == null || username_ == null) throw Exception("uid or username_ is null!");
      id = uid;
      username = username_;
      _publicDoc = instance.collection('categories').doc('public');
      _privateDoc = instance.collection('categories').doc(id);
    }else{
      id = await getCurrentUserID();
      username = await getCurrentUserUsername();
    }

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

  /// Returns a category from the database with the given name [_category].
  ///
  /// If the category is not found, returns null.
  Future<Category> getCategory(String _category, {FirebaseFirestore? instance, String? uid, String? username_}) async {
    String? id;
    String? username;
    if(instance != null){
      if(uid == null || username_ == null) throw Exception("uid or username_ is null!");
      id = uid;
      username = username_;
      _publicDoc = instance.collection('categories').doc('public');
      _privateDoc = instance.collection('categories').doc(id);
    }else{
      id = await getCurrentUserID();
      username = await getCurrentUserUsername();
    }

    if (username == null) {
      throw UserNotLoggedInException();
    }
    DocumentSnapshot doc = await _privateDoc.get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (data.containsKey(_category)) {
        return Category(
            name: _category, color: Color(data[_category] as int), UID: uid, firestore: instance);
      }
    }
    return throw CategoryNotFoundException();
  }
}
