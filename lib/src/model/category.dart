import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:queasy/src/model/profile.dart';
import 'package:queasy/src/model/question.dart';
import 'package:queasy/utils/exceptions.dart';

/// This is the model of the Category.
///
/// [name] is the name of the category.
///
/// [color] is the color of the category.
///
/// [_publicDoc] is the reference to the public categories in Firestore.
///
/// [_privateDoc] is the reference to the private categories in Firestore where categories of the current user are stored.
///
/// [_isPublic] is a boolean that determines if the category is public or private.
class Category {
  DocumentReference _publicDoc = FirebaseFirestore.instance.collection('categories').doc('public');
  DocumentReference _privateDoc = FirebaseFirestore.instance.collection('categories').doc(getCurrentUserID());

  late Color _color;
  late String _category;
  late bool _isPublic;

  /// Constructor for the [Category] class.
  ///
  /// [category] is the name of the [Category] and [color] is the color of the [Category].
  Category({required String category, required Color color}) {
    _category = category;
    _color = color;
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
  ///
  /// [newName] is the new name of the [Category].
  Future<void> changeNameOfCategory(String newName) async {
    String? username = getCurrentUserID();
    if (username == null) {
      throw UserNotLoggedInException();
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
      throw UserNotLoggedInException();
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
      throw UserNotLoggedInException();
    }
    return _category;
  }

  /// Get the color of the current [Category].
  Color getColor() {
    String? username = getCurrentUserID();
    if (username == null) {
      throw UserNotLoggedInException();
    }
    return _color;
  }

  /// Get the list of [Question]s in the current public [Category].
  Future<List<Question>> getQuestionsFromPublicCategory() async {
    String? username = getCurrentUserID();
    if (username == null) {
      throw UserNotLoggedInException();
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
      throw UserNotLoggedInException();
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

  /// Used to delete a given [Question] out of the category.
  ///
  /// [question] is the [Question] that should be deleted. [firestore] is not required instance of the database and is only used for testing.
  Future<void> deleteQuestion(Question question, {FirebaseFirestore? firestore}) async {
    String? username = getCurrentUserID();
    if (firestore == null) {
      firestore = FirebaseFirestore.instance;
    }

    if (username == null) {
      throw UserNotLoggedInException();
    }
    // delete the question from the private category
    await firestore
        .collection('categories')
        .doc(username)
        .collection(_category)
        .doc(question.ID)
        .delete();
  }

  /// Used to add a given [Question] to the category in the database.
  ///
  /// [question] is the [Question] that should be added. [firestore] is not required instance of the database and is only used for testing.
  Future<void> addQuestion(Question question, {FirebaseFirestore? firestore}) async {
    String? username = getCurrentUserID();

    if (firestore == null) {
      firestore = FirebaseFirestore.instance;
    }

    if (username == null) {
      throw UserNotLoggedInException();
    }

    // count how many questions already exist inside of the given category
    int count = 0;
    await firestore
        .collection('categories')
        .doc(username)
        .collection(_category)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        count++;
      });
    });

    // create a variable newID from 'question' + count
    String newID;
    print(question.questionID);
    if(question.questionID == null) {
      newID = await getNextID();
    } else {
      newID = question.questionID!;
    }
    print(newID);
    await firestore
        .collection('categories')
        .doc(username)
        .collection(_category)
        .doc(newID)
        .set(question.toJson());

    print(count);
    if(count == 1){
      // delete the question from the public category which is called question-1
      await firestore
          .collection('categories')
          .doc(username)
          .collection(_category)
          .doc('question-1')
          .delete();
    }
  }

  /// Retrieves a [Question] from the private category with a given [id].
  Future<Question> getQuestion(String id, {bool public = false}) async{
    String? username = getCurrentUserID();
    if (username == null) {
      throw UserNotLoggedInException();
    }
    late Question question;

    if (public == false) {
      await _privateDoc
          .collection(_category)
          .doc(id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          question =
              Question.fromJson(documentSnapshot.data() as Map<String, dynamic>);
        } else {
          print('Document does not exist on the database');
        }
      });
    } else {
      await _publicDoc
          .collection(_category)
          .doc(id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          question = Question.fromJson(documentSnapshot.data() as Map<String, dynamic>);
        } else {
          print('Document does not exist on the database');
        }
      });
  }

    if (question == null) {
      throw Exception('Question is null');
    }
    else{
      return question;
    }
  }

  /// Calculates the next ID for a question in the category.
  ///
  /// This is used to create a unique ID for a question in the category. It finds the highest ID and adds 1 to it.
  Future<String> getNextID() async{
    int count = -1;
    await FirebaseFirestore.instance
        .collection('categories')
        .doc(getCurrentUserID())
        .collection(_category)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // take the biggest ID and add 1 to it
        if (int.parse(doc['ID'].substring(8)) > count) {
          count = int.parse(doc['ID'].substring(8));
          print("count: " + count.toString());
        }
      });
    });
    count = count + 1;
    return 'question'+ count.toString();
  }

  Future<String> randomizer({FirebaseFirestore? firestore, bool public = false}) async {
    String? username = getCurrentUserID();
    if (username == null) {
      throw UserNotLoggedInException();
    }

    if (firestore == null) {
      firestore = FirebaseFirestore.instance;
    }

    // count the amount of documents in the public category
    int count = 0;

    if (public == true) {
      await firestore
          .collection('categories')
          .doc('public')
          .collection(_category)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          count++;
        });
      });
    } else {
      await firestore
          .collection('categories')
          .doc(username)
          .collection(_category)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          count++;
        });
      });
    }

    // create a random integer between 0 and count
    int random = Random().nextInt(count);

    String id = 'question' + random.toString();

    return id;
  }
}
