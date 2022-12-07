import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:queasy/src/model/question.dart';

String getCurrentUserID() {
  return 'Savo';
}

class Category {
  /// Collection [DocumentReference] for the public [Category] location in the database.
  DocumentReference _publicDoc =
      FirebaseFirestore.instance.collection('categories').doc('public');

  /// Collection [DocumentReference] for the private [Category] location in the database.
  DocumentReference _privateDoc = FirebaseFirestore.instance
      .collection('categories')
      .doc(getCurrentUserID());

  /// [Color] of the [Category].
  late Color _color;

  /// Default value of the [Category] is -1.
  late String _category;

  /// Flag to check if the [Category] is public or private.
  late bool _isPublic;

  /// Constructor for the [Category] class.
  ///
  /// [category] is the name of the [Category] and [color] is the color of the [Category].
  Category({required String category, required Color color}) {
    _category = category;
    _color = color;
    // this._createNewCategory(_category, _color);
  }

  /// Constructor for the [Category] class for testing.
  ///
  /// [category] is the name of the [Category], [color] is the color of the [Category]
  /// and [FirebaseFirestore] is the Fake instance of the database
  Category.test(
      {required String category,
      required Color color,
      required FirebaseFirestore firestore}) {
    _category = category;
    _color = color;
    _publicDoc = firestore.collection('categories').doc('public');
    _privateDoc = firestore.collection('categories').doc(getCurrentUserID());
    // this._createNewCategory(_category, _color);
  }

  /// Constructor for the [Category] from JSON data.
  ///
  /// [json] is the JSON data of the [Category]. Throws an error if the [json] is not in the correct format.
  Category.fromJSON(Map<String, dynamic> json) {
    if (json.length != 1) {
      throw Exception('Invalid JSON format for Category');
    }
    _category = json.keys.first;
    _color = Color(json[_category]);
  }

  /// Maps the [Category] to a JSON format.
  Map<String, dynamic> toJSON() {
    return {_category: _color.value};
  }

  /// Changes the name of the current [Category].
  Future<void> changeNameOfCategory(String newName) async {
    String? username = getCurrentUserID();
    if (username == null) {
      throw Exception('User is not logged in');
    }
    _privateDoc.update({
      _category: FieldValue.delete(),
    });
    _privateDoc.set({
      newName: _color.value,
    });
    // copy collection from Firestore old category to 'newName'
    // and delete the old collection
    await _privateDoc
        .collection(_category)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _privateDoc
            .collection(newName)
            .doc(doc.id)
            .set(doc.data() as Map<String, dynamic>);
      });
    });

    // iterate through all questions in the category and delete them
    await _privateDoc.collection(_category).get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });

    _category = newName;
  }

  /// Sets the color of the current [Category]
  ///
  /// [color] is the color of the [Category].
  Future<void> setColor(Color col) async {
    String? username = getCurrentUserID();
    if (username == null) {
      throw Exception('User is not logged in');
    }
    _color = col;
    _privateDoc.update({
      _category: col.value,
    });
  }

  /// Get the name of the current [Category].
  String getCategory() {
    String? username = getCurrentUserID();
    if (username == null) {
      throw Exception('User is not logged in');
    }
    return _category;
  }

  /// Get the color of the current [Category].
  Color getColor() {
    String? username = getCurrentUserID();
    if (username == null) {
      throw Exception('User is not logged in');
    }
    return _color;
  }

  /// Get the list of [Question]s in the current public [Category].
  Future<List<Question>> getQuestionsFromPublicCategory(String cat) async {
    String? username = getCurrentUserID();
    if (username == null) {
      throw Exception('User is not logged in');
    }

    List<Question> questions = [];

    // get all document id from public categories
    await _publicDoc
        .collection(_category)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        questions.add(Question.fromJson(doc.data() as Map<String, dynamic>));
      });
    });
    return questions;
  }

  /// Get the list of [Question]s in the current private [Category].
  Future<List<Question>> getQuestionsFromPrivateCategory() async {
    String? username = getCurrentUserID();
    if (username == null) {
      throw Exception('User is not logged in');
    }

    List<Question> questions = [];
    // get all document id from public categories
    await _privateDoc
        .collection(_category)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        questions.add(Question.fromJson(doc.data() as Map<String, dynamic>));
      });
    });
    return questions;
  }
}
