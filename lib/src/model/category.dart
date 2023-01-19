import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:queasy/src/model/profile.dart';
import 'package:queasy/src/model/question.dart';
import 'package:queasy/utils/exceptions.dart';


/// The Category class is responsible for being an instance of the category and also,
/// for editing the private category. That includes adding, removing and editing the questions which
/// are inside of the category by using [addQuestion], [removeQuestion] and [editQuestion] methods.
class Category {
  /// Represents the document reference for private categories.
  late DocumentReference _privateDoc;

  /// Represents the name of the category.
  late String _name;

  /// Represents the color of the category.
  late Color _color;

  /// Represents the UID of the currently logged in user.
  late String? UID;

  /// Represents the instance of the [FirebaseFirestore].
  late FirebaseFirestore? firestore;

  /// Represents the storing place for retrieved question.
  late Question getQuestionTemp;

  /// A getter for the name of the category.
  get name => _name;

  /// A getter for the color of the category.
  get color => _color;

  /// Constructor for the [Category] class.
  ///
  /// [name] is the name of the [Category] and [color] is the color of the [Category].
  ///
  /// [firestore] is the instance of the Firestore database. If it is passed,
  /// the constructor assumes that the developer is in testing and will
  /// initialize the [UID] with a default value and [_publicDoc]
  /// with the references in the test database.
  ///
  /// If it is not passed, the constructor will initialize the [UID] with the
  /// current user's [UID] and [_publicDoc] with the references
  /// in the production database.
  Category(
      {required String name,
      Color color = Colors.blue,
      FirebaseFirestore? firestore,
      String? UID = "test123456789"}) {
    _name = name;
    _color = color;
    if (firestore == null) {
      this.UID = getCurrentUserID();
      if(this.UID == null) throw new UserNotLoggedInException();
      this.firestore = FirebaseFirestore.instance;
      this._privateDoc = FirebaseFirestore.instance
          .collection('categories')
          .doc(getCurrentUserID());
    } else {
      this.UID = UID;
      this.firestore = firestore;
      _privateDoc = firestore.collection('categories').doc(UID);
    }
  }

  /// Constructor for the [Category] from JSON data. It is used for retrieving the category from the database.
  ///
  /// [json] is the JSON data of the [Category]. Throws an error if the [json] is not in the correct format.
  Category.fromJSON(Map<String, dynamic> json) {
    if (json.length != 1) {
      throw JSONIsNotFormattedCorrectlyException();
    }
    _name = json.keys.first;
    _color = Color(json[_name]);
  }

  /// Maps the current [Category] to a JSON format which includes the name of the category [_name] and the
  /// color of the category [_color] which is converted to the number value.
  Map<String, dynamic> toJSON() {
    return {_name: _color.value};
  }

  /// Sets the new color of the current [Category]
  ///
  /// [color] is the new color of the [Category].
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

  /// A getter for the name of the category [_name].
  String getName() {
    String? username = UID;
    if (username == null) {
      throw UserNotLoggedInException();
    }
    return _name;
  }

  /// A getter for the color [_color] of the current private [Category].
  Color getColor() {
    String? username = UID;
    if (username == null) {
      throw UserNotLoggedInException();
    }
    return _color;
  }

  /// Get the list of [Question]s in the current private [Category]. If user is not logged in, it throws an error [UserNotLoggedInException].
  ///
  /// It iterates through the list of [Question]s in the current private [Category] and returns the list of [Question]s.
  /// If the list is empty or there is only one question with the id 'question-1', it returns an empty list. 'question-1' is there because
  /// the collection can't be empty.
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
        if (doc.data() != null &&
            (doc.data() as Map<String, dynamic>)["ID"] != "question-1") {
          questions.add(Question.fromJson(
              doc.data() as Map<String, dynamic>, _name, username));
        }
      });
    });
    questions.sort((a, b) => a.questionId!.compareTo(b.questionId!));
    return questions;
  }

  /// Used to delete a given [Question] out of the category.
  ///
  /// [question] is the [Question] that should be deleted. If user is not logged in, it throws an error [UserNotLoggedInException].
  /// If there is one question in the database, it adds the 'question-1' default question to the database and then deletes it.
  /// Then it iterates over the quizzes in the database and deletes the references to the deleted question of each quiz.
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
        _privateDoc
            .collection(_name)
            .doc("question-1")
            .set({"ID": "question-1"});
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
          firestore?.collection('quizzes').doc(currentQuizId).delete();
        } else {
          firestore?.collection('quizzes').doc(currentQuizId).update({
            "questionIds": questionIDs,
          });
        }
      });
    });
  }

  /// Used to add a given [Question] to the category in the database.
  ///
  /// [question] is the [Question] that should be added. If user is not logged in, it throws an error [UserNotLoggedInException].
  /// First it adds the question to the database and then it counts the number of questions in the category. If there is only one question,
  /// it will delete the 'question-1' default question at the end of the method. After it counts, it calls [getNextID] method which finds out
  /// the next ID for the question. Then it adds the question to the database with the new ID.
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
    newID = await getNextID();
    question.questionId = newID;
    await firestore
        ?.collection('categories')
        .doc(UID)
        .collection(_name)
        .doc(newID)
        .set(question.toJson());

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

  /// Retrieves a [Question] from any category with a given [id].
  ///
  /// If user is not logged in, it throws an error [UserNotLoggedInException]. If the [categoryName] is empty string,
  /// it replaces it with the [_name] of the current private [Category]. If the [public] is true, it will look for the question
  /// in the 'public' category document and if it is false, it will look for the question in the private category document. If the
  /// question is not found, it throws an error [QuestionNotFoundException].
  Future<Question> getQuestion(String id, {bool public = false, String categoryName = ""}) async {
    if (categoryName == "") {
      categoryName = _name;
    }

    if (UID == null || UID == '') {
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
              documentSnapshot.data() as Map<String, dynamic>,
              categoryName,
              UID!);
        } else {
          throw QuestionNotFoundException();
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
              documentSnapshot.data() as Map<String, dynamic>,
              categoryName,
              UID!);
        } else {
          throw QuestionNotFoundException();
        }
      });
    }
    return this.getQuestionTemp;
  }

  /// Retrieves a [Question] from only the private category with a given [id].
  ///
  /// If user is not logged in, it throws an error [UserNotLoggedInException]. It will look for the question in the private category document. If the
  /// question is not found, it throws an error [QuestionNotFound].
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
        throw QuestionNotFoundException();
      }
    });
    return question;
  }

  /// Calculates the next ID for a question in the current category.
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
        }
      });
    });
    count = count + 1;
    return 'question' + count.toString();
  }

  /// Gets the id of the random question in the database
  ///
  /// This is used to get the id of the random question in the database. It gets the id of the random question in the database and returns it.
  /// If the user is not logged in, it throws an error [UserNotLoggedInException]. It goes through all the questions, saves the [ID]s in the list [keys]
  /// and chooses the random [ID] from the list. If the list is empty, it throws an error [QuestionNotFoundException].
  Future<String> randomizer({bool public = false}) async {
    if (UID == null) {
      throw UserNotLoggedInException();
    }
    List<String> keys = [];
    if (public == true) {
      await firestore
          ?.collection('categories')
          .doc('public')
          .collection(_name)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          (doc.data() as Map<String, dynamic>).forEach((key, value) {
            if(key == 'ID') keys.add(value);
          });
        });
      });
    } else {
      await firestore
          ?.collection('categories')
          .doc(UID)
          .collection(_name)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs..forEach((doc) {
          (doc.data() as Map<String, dynamic>).forEach((key, value) {
            if(key == 'ID') keys.add(value);
          });
        });
      });
    }
    if(keys.isEmpty) throw QuestionNotFoundException();
    // create a random integer between 0 and count
    int random = Random().nextInt(keys.length);

    String id = keys[random];

    return id;
  }

  /// Deletes from Firestore a quiz that the user created.
  ///
  /// Takes a String with the [id] of the quiz as parameter to perform the
  /// database search. It also takes an optional parameter [firestore] to
  /// allow for testing. this parameter should only be passed to the function
  /// on tests to mock the database.
  static Future<void> deleteQuiz({
    required String id,
    FirebaseFirestore? firestore,
  }) async {
    if (firestore == null) {
      firestore = FirebaseFirestore.instance;
    }

    await firestore.collection('quizzes').doc(id).delete();
  }
}
