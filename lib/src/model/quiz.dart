import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queasy/src/model/category.dart';
import 'package:queasy/src/model/profile.dart';
import 'package:queasy/src/model/question.dart';
import '../../utils/exceptions.dart';

class Quiz {
  late String id;
  late Category category;
  late int noOfQuestions;
  late String? ownerID, categoryName;
  List<Question> _questions = [];
  List<String> _usedQuestions = [];
  late FirebaseFirestore? firestore;
  late bool isPublic;

  get questions => _questions;

  Quiz.createRandom({
    required this.category,
    required this.noOfQuestions,
    required this.isPublic,
    this.firestore,
  }) {
    firestore ?? FirebaseFirestore.instance;
    getRandomQuestions();
  }

  Quiz.retrieveFromID({
    required this.id,
    required this.noOfQuestions,
    this.firestore,
  }) {
    isPublic = false;
    if (firestore == null) {
      firestore = FirebaseFirestore.instance;
    }
    retrieveQuizFromId();
  }

  /// This method is supposed to create a random 8 character String
  /// This is used to create the ID of the quiz
  /// a-z A-Z 0-9
  String createID() {
    String id = "";
    for (int i = 0; i < 8; i++) {
      int random = Random().nextInt(62);
      if (random < 10) {
        id += random.toString();
      } else if (random < 36) {
        id += String.fromCharCode(random + 55);
      } else {
        id += String.fromCharCode(random + 61);
      }
    }
    return id;
  }

  Future<void> assignUniqueID() async {
    String tempID = createID();

    // count how many questions already exist inside of the given category
    await firestore
        ?.collection('quizzes')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (tempID == doc['id']) {
          assignUniqueID();
        }
      });
    });

    this.id = tempID;
  }

  Future<Quiz> getRandomQuestions() async {

    if (isPublic == false) {
      if (getCurrentUserID() == null) {
        throw UserNotLoggedInException();
      }
      this.ownerID = getCurrentUserID();

      await assignUniqueID();
    } else {
      this.ownerID = 'public';
      this.id = 'whatever';
    }

    /// for the number of questions in the quiz, get a random question from the category
    for (int i = 0; i < noOfQuestions; i++) {
      /// create a random id from category.randomizer
      /// check if the id is already in the list of used questions
      /// if it is, create a new id
      /// if it is not, add it to the list of used questions
      /// add the question to the list of questions
      String tempID =
          await category.randomizer(firestore: firestore, public: isPublic);
      while (_usedQuestions.contains(tempID)) {
        tempID =
            await category.randomizer(firestore: firestore, public: isPublic);
      }
      _usedQuestions.add(tempID);
      Question tempQuestion =
          await category.getQuestion(tempID, public: isPublic);
      _questions.add(tempQuestion);
    }

    return this;
  }

  /// This method is used to store the quiz into the database
  Future<void> storeQuiz() async {
    await firestore?.collection('quizzes').doc(id).set({
      'id': id,
      'creatorID': ownerID,
      'category': category.name,
      'questionIds': _questions,
    });
  }

  Future<Quiz> retrieveQuizFromId() async {
    print('inside retrieveQuizFromId method. Id: $id');
    this.isPublic = false;

    firestore ?? FirebaseFirestore.instance;

    await firestore
        ?.collection('quizzes')
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      print('it got the collection');
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
        this.id = documentSnapshot['id'];
        this.ownerID = documentSnapshot['creatorID'];
        this.categoryName = documentSnapshot['category'];
        this.noOfQuestions = documentSnapshot['questionIds'].length;
        /// add all questionIds to the list of used questions
        for (int i = 0; i < noOfQuestions; i++) {
          _usedQuestions.add(documentSnapshot['questionIds'][i]);
        }
      } else {
        print('Document does not exist on the database');
      }
    });

    String catName = categoryName!;

    for (int i = 0; i < noOfQuestions; i++) {
      Question tempQuestion =
          await category.getQuestion(_usedQuestions[i], public: isPublic, categoryName: catName);
      _questions.add(tempQuestion);
    }

    return this;
  }
}

