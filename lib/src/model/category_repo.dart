import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:queasy/src.dart';
import '../../utils/exceptions.dart';

/// Gathers all the categories available from the user in the variable
/// [_publicDoc] for public categories and [_privateDoc] for categories
/// created by the user.
class CategoryRepo {
  /// Represents the document where public categories are stored.
  late DocumentReference _publicDoc;

  /// Represents the document there private categories of the current user are stored.
  late DocumentReference _privateDoc;

  /// Represents the current user's UID.
  String? UID;

  /// Constructor for the [CategoryRepo] class. If the [instance_] is not null, it assumes that it is
  /// in the testing mode and it will take the instance and use that for setting the [DocumentReference]s [_publicDoc] and [_privateDoc].
  /// If the [instance_] is null, it will take the current user's UID and use that for setting the [DocumentReference]s [_publicDoc] and [_privateDoc].
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
  /// [categoryName] is the name of the [Category] and [color] is the color of the [Category]. If the [instance] is not null, it assumes that it is
  /// in the testing mode and it will take the instance and use that for setting the [DocumentReference]s [_publicDoc] and [_privateDoc].
  /// First it checks if the category already exists in the database. Then it updates the color and finally ir creates the default question 'question-1'
  Future<void> createCategory(String categoryName, Color color, {FirebaseFirestore? instance, String? uid}) async {
    String? id;
    if(instance != null){
      if(uid == null) throw UserNotLoggedInException();
      id = uid;
      _publicDoc = instance.collection('categories').doc('public');
      _privateDoc = instance.collection('categories').doc(id);
    }else{
      id = await getCurrentUserID();
    }
    if (id == null) {
      throw UserNotLoggedInException();
    }
    await _privateDoc.get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists && documentSnapshot.data() != null) {
        // check if the categoryName exists already in the document
        (documentSnapshot.data() as Map<String, dynamic>).forEach((key, value) {
          if (key == categoryName) {
            throw CategoryAlreadyExistsException();
          }
        });
      }
    });
    await _privateDoc.update({
      categoryName: color.value,
    });
    // add the default questions
    await _privateDoc
        .collection(categoryName)
        .doc('question-1')
        .set({'ID': 'question-1'});
  }

  /// Deletes the collection of the current user which stores all of the user's categories.
  ///
  /// It is used when deleting the user. First it checks if the user is logged in. If not, it throws the [UserNotLoggedInException] exception.
  /// Then it just deletes the collection of the private document [_privateDoc].
  Future<void> deleteUserCollection() async {
    String? id = await getCurrentUserID();
    if (id == null) {
      throw UserNotLoggedInException();
    }
    await _privateDoc.delete();
  }

  /// Deletes the category from the database.
  ///
  /// [_category] is the name of the category being deleted. [instance] is the instance of the Firestore database. If it is passed,
  /// the constructor assumes that the developer is in testing and will initialize the [UID] with a default value and [_publicDoc]
  /// with the references in the test database. If user is not logged in, it throws an error [UserNotLoggedInException].
  /// It first deletes the color of the category from the database. Then it iterates through all the questions and deletes them.
  /// Afterwards, it deletes all the quizzes where is this category mentioned.
  Future<void> deleteCategory(String _category, {FirebaseFirestore? instance, String? uid = "defaultID"}) async {
    String? id;
    if(instance != null){
      if(uid == null) throw Exception("uid or username_ is null!");
      id = uid;
      _publicDoc = instance.collection('categories').doc('public');
      _privateDoc = instance.collection('categories').doc(id);
    }else{
      id = await getCurrentUserID();
      instance = FirebaseFirestore.instance;
    }
    if (id == null) {
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
    // iterate through the quizzes in Firestore and delete where the attribute category is equals to the _category
    await instance.collection('quizzes').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        if(ds['category'] == _category){
          ds.reference.delete();
        }
      }
    });
  }

  /// Gets the list of [String] names public [Category]s.
  ///
  /// If the [instance] is not null, it assumes that it is in the testing mode and it will take the instance
  /// and use that for setting the [DocumentReference]s [_publicDoc] and [_privateDoc].
  /// If the user is not logged in, it throws an error [UserNotLoggedInException].
  /// It gets the data from the [_publicDoc] and returns a list of [String] names of the categories.
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

  /// Get the list of [String] names of current user's private [Category]s.
  ///
  /// If the [instance] is not null, it assumes that it is in the testing mode and it will take the instance
  /// and use that for setting the [DocumentReference]s [_publicDoc] and [_privateDoc].
  /// If the user is not logged in, it throws an error [UserNotLoggedInException].
  /// It gets the data from the [_privateDoc] and returns a list of [String] names of the categories.
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
  /// If the [instance] is not null, it assumes that it is in the testing mode and it will take the instance
  /// and use that for setting the [DocumentReference]s [_publicDoc] and [_privateDoc].
  /// If the user is not logged in, it throws an error [UserNotLoggedInException].
  /// It gets the data from the [_privateDoc] and returns a [Category] object.
  /// If the category is not found, it throws an error [CategoryNotFoundException].
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
            name: _category, color: Color(data[_category] as int), UID: id, firestore: instance);
      }
    }
    return throw CategoryNotFoundException();
  }
}
