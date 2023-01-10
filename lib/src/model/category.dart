import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:queasy/src/model/profile.dart';
import 'package:queasy/src/model/question.dart';
import 'package:queasy/utils/exceptions.dart';

import '../../src.dart';
/// This is the model of the Category.
///
/// [name] is the name of the category.
///
/// [color] is the color of the category.
///
/// [_publicDoc] is the reference to the public categories in Firestore.
///
/// [_privateDoc] is the reference to the private categories in Firestore for the currently logged in user.
///
/// [UID] is the uid of the currently logged in user.
///
/// [_isPublic] is a boolean that determines if the category is public or private.
///
/// [firestore] is the instance of the [FirebaseFirestore], it is used for mocking of the Firebase for unit testing.
class Category {
  late DocumentReference _publicDoc;
  late DocumentReference _privateDoc;

  late String _name;
  late Color _color;
  late bool _isPublic;
  late String? UID;
  late FirebaseFirestore? firestore;
  late Question getQuestionTemp;

  /// Getter for the [_name]
  get name => _name;

  /// Getter for the [_color]
  get color => _color;

  /// Constructor for the [Category] class.
  ///
  /// [name] is the name of the [Category] and [color] is the color of the [Category].
  ///
  /// [firestore] is the instance of the Firestore database. If it is passed,
  /// the constructor assumes that the developer is in testing and will
  /// initialize the [UID] with a default value and [_privateDoc] and [_publicDoc]
  /// with the references in the test database.
  ///
  /// If it is not passed, the constructor will initialize the [UID] with the
  /// current user's [UID] and [_privateDoc] and [_publicDoc] with the references
  /// in the production database.
  Category({required String name, Color color = Colors.blue, FirebaseFirestore? firestore, String? UID = "test123456789"}) {
    _name = name;
    _color = color;
    if(firestore == null) {
      this.UID = getCurrentUserID();
      this.firestore = FirebaseFirestore.instance;
      this._publicDoc = FirebaseFirestore.instance.collection('categories').doc('public');
      this._privateDoc = FirebaseFirestore.instance
          .collection('categories')
          .doc(getCurrentUserID());
    }
    else {
      this.UID = UID;
      this.firestore = firestore;
      _publicDoc = firestore.collection('categories').doc('public');
      _privateDoc = firestore.collection('categories').doc(UID);
    }
  }

  /// Constructor for the [Category] from JSON data.
  ///
  /// [json] is the JSON data of the [Category]. Throws an error if the [json] is not in the correct format.
  Category.fromJSON(Map<String, dynamic> json) {
    if (json.length != 1) {
      throw Exception('Invalid JSON format for Category');
    }
    _name = json.keys.first;
    _color = Color(json[_name]);
  }

  /// Maps the [Category] to a JSON format.
  Map<String, dynamic> toJSON() {
    return {_name: _color.value};
  }

  /// Changes the name of the current [Category].
  ///
  /// [newName] is the new name of the [Category].
  Future<void> changeNameOfCategory(String newName) async {
    String? username = UID;
    if (username == null) {
      throw UserNotLoggedInException();
    }
    _privateDoc.update({
      _name: FieldValue.delete(),
    });
    _privateDoc.set({
      newName: _color.value,
    });
    // copy collection from Firestore old category to 'newName'
    // and delete the old collection
    await _privateDoc
        .collection(_name)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _privateDoc
            .collection(newName)
            .doc(doc.id)
            .set(doc.data() as Map<String, dynamic>);
      });
    });

    if (this.firestore == null){
      this.firestore = FirebaseFirestore.instance;
    }

    var newDocumentRef = this.firestore!.collection('leaderboard').doc(username + '-' + newName);
    // iterate over the leaderboard in the Firestore, and copy all the record to the new leaderboard with the new name
    await this.firestore!.collection('leaderboard').doc(username + '-' + this._name).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

        for (String key in data.keys) {
          newDocumentRef.update(data[key]);
        }
      }
    });
    await this.firestore!.collection('leaderboard').doc(username + '-' + this._name).delete();

    // iterate over quizzes collection, find all documents which have the attribute 'category' which equals to _name and change it to newName
    await this.firestore!.collection('quizzes').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(doc.exists){
          if ((doc.data()! as Map<String, dynamic>)['category'] == this._name) {
            doc.reference.update({'category': newName});
          }
        }

      });
    });

    // iterate through all questions in the category and delete them
    await _privateDoc.collection(_name).get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });

    _name = newName;
  }

  /// Sets the color of the current [Category]
  ///
  /// [color] is the color of the [Category].
  Future<void> setColor(Color col) async {
    String? username = UID;
    if (username == null) {
      throw UserNotLoggedInException();
    }
    _color = col;
    _privateDoc.update({
      _name: col.value,
    });
  }

  /// Get the name of the current [Category].
  String getName() {
    String? username = UID;
    if (username == null) {
      throw UserNotLoggedInException();
    }
    return _name;
  }

  /// Get the color of the current [Category].
  Color getColor() {
    String? username = UID;
    if (username == null) {
      throw UserNotLoggedInException();
    }
    return _color;
  }

  /// Get the list of [Question]s in the current private [Category]. If user is not logged in, it throws an error.
  Future<List<Question>> getAllQuestions() async {
    String? username = UID;
    if (username == null) {
      throw UserNotLoggedInException();
    }

    List<Question> questions = [];
    // get all document id from public categories
    await _privateDoc
        .collection(_name)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // if there are no questions or the only question is 'question-1' which is default question, it returns an empty list
        if(doc.data() != null && (doc.data() as Map<String, dynamic>)["ID"] != "question-1") {
          questions.add(Question.fromJson(doc.data() as Map<String, dynamic>, _name, username));
        }
      });
    });
    return questions;
  }

  /// Used to delete a given [Question] out of the category.
  ///
  /// [question] is the [Question] that should be deleted. [firestore] is not required instance of the database and is only used for testing.
  Future<void> deleteQuestion(Question question) async {

    if (UID == null) {
      throw UserNotLoggedInException();
    }

    // check if there is only one question left in the Firestore, if there is, add a question-1 question
    await _privateDoc
        .collection(_name)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.length == 1) {
        _privateDoc.collection(_name).doc("question-1").set({
          "ID": "question-1"
        });
      }
    });

    // delete the question from the private category
    await firestore
        ?.collection('categories')
        .doc(UID)
        .collection(_name)
        .doc(question.id)
        .delete();

    List<String> questionIDs = [];
    String currentQuizId = "";
    await firestore
        ?.collection('quizzes')
        .where('creatorID', isEqualTo: UID)
        .where('category', isEqualTo: question.category)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        currentQuizId = doc.id;
        Map<String, dynamic> quiz = doc.data() as Map<String, dynamic>;
        questionIDs = quiz["questionIds"] as List<String>;
        for (int i = 0; i < questionIDs.length; i++) {
          if (questionIDs[i] == question.id) {
            questionIDs.removeAt(i);
            break;
          }
        }
        if (questionIDs.isEmpty) {
          firestore
              ?.collection('quizzes')
              .doc(currentQuizId)
              .delete();
        } else {
          firestore
              ?.collection('quizzes')
              .doc(currentQuizId)
              .update({
            "questionIds": questionIDs,
          });
        }
      });
    });

  }

  /// Used to add a given [Question] to the category in the database.
  ///
  /// [question] is the [Question] that should be added. [firestore] is not required instance of the database and is only used for testing.
  Future<void> createQuestion(Question question) async {

    if (UID == null) {
      throw UserNotLoggedInException();
    }

    // count how many questions already exist inside of the given category
    int count = 0;
    await firestore
        ?.collection('categories')
        .doc(UID)
        .collection(_name)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        count++;
      });
    });

    // create a variable newID from 'question' + count
    String newID;
    //print(question.questionId);
    newID = await getNextID();
    question.questionId = newID;
    //print(newID);
    await firestore
        ?.collection('categories')
        .doc(UID)
        .collection(_name)
        .doc(newID)
        .set(question.toJson());

    //print(count);
    if (count == 1) {
      // delete the question from the public category which is called question-1
      await firestore
          ?.collection('categories')
          .doc(UID)
          .collection(_name)
          .doc('question-1')
          .delete();
    }
  }

  /// Retrieves a [Question] from the private category with a given [id].
  Future<Question> getQuestion(String id, {bool public = false, String categoryName = ""}) async {

    if (categoryName == "") {
      categoryName = _name;
    }

    if (UID == null) {
      throw UserNotLoggedInException();
    }

    if (public == false) {
      await firestore
          ?.collection('categories')
          .doc(UID)
          .collection(categoryName)
          .doc(id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          this.getQuestionTemp = Question.fromJson(
              documentSnapshot.data() as Map<String, dynamic>, categoryName, UID!);
        } else {
          print('Document does not exist on the database');
        }
      });
    } else {
      await firestore
          ?.collection('categories')
          .doc('public')
          .collection(categoryName)
          .doc(id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          this.getQuestionTemp = Question.fromJson(
              documentSnapshot.data() as Map<String, dynamic>, categoryName, UID!);
        } else {
          print('Document does not exist on the database');
        }
      });
    }

    if (this.getQuestionTemp == null) {
      throw Exception('Question is null');
    } else {
      return this.getQuestionTemp;
    }
  }

  Future<Question> getPrivateQuestion(String id, String ownerID) async {

    if (UID == null) {
      throw UserNotLoggedInException();
    }
    late Question question;
    await firestore
        ?.collection('categories')
        .doc(ownerID)
        .collection(_name)
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        question = Question.fromJson(
            documentSnapshot.data() as Map<String, dynamic>, _name, UID!);
      } else {
        print('Document does not exist on the database');
      }
    });

    if (question == null) {
      throw Exception('Question is null');
    } else {
      return question;
    }
  }

  /// Calculates the next ID for a question in the category.
  ///
  /// This is used to create a unique ID for a question in the category. It finds the highest ID and adds 1 to it.
  Future<String> getNextID() async {

    if (UID == null) {
      throw UserNotLoggedInException();
    }
    int count = -1;
    await firestore
        ?.collection('categories')
        .doc(UID)
        .collection(_name)
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
    return 'question' + count.toString();
  }

  Future<String> randomizer({bool public = false}) async {

    if (UID == null) {
      throw UserNotLoggedInException();
    }

    // count the amount of documents in the public category
    int count = 0;

    if (public == true) {
      await firestore
          ?.collection('categories')
          .doc('public')
          .collection(_name)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          count++;
        });
      });
    } else {
      await firestore
          ?.collection('categories')
          .doc(UID)
          .collection(_name)
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

  Future<void> deleteQuiz(String id) async {

    await firestore
        ?.collection('quizzes').doc(id).delete();
  }
}
