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
  late String? ownerID, name;
  List<Question> _questions = [];
  List<String> _usedQuestions = [];
  late FirebaseFirestore? firestore;
  late bool isPublic;
  String? UID = getCurrentUserID();

  get questions => _questions;

  Quiz.createRandom({
    required this.category,
    required this.noOfQuestions,
    required this.isPublic,
    this.name,
    this.firestore,
  }) {
    if (firestore == null) {
      firestore = FirebaseFirestore.instance;
    }
    else {
      UID = "test123456789";
    }
    getRandomQuestions();
  }

  Quiz({
    //required this.id,
    this.firestore,
  }) {
    category = Category(name: 'default');
    // isPublic = false;
    if (firestore == null) {
      firestore = FirebaseFirestore.instance;
    }
    else {
      UID = "test123456789";
    }
    // retrieveQuizFromId();
  }

  ///DO NOT USE THIS!!!
  Quiz.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.name = json['name'];
    this.ownerID = json['creatorID'];
    this.category = new Category(name: json['category']);
    this.noOfQuestions = json['questionIds'].length;

    /// add all questionIds to the list of used questions
    for (int i = 0; i < noOfQuestions; i++) {
      _usedQuestions.add(json['questionIds'][i]);
    }
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
      if (UID == null) {
        throw UserNotLoggedInException();
      }
      this.ownerID = UID;

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
          await category.randomizer(public: isPublic);
      while (_usedQuestions.contains(tempID)) {
        tempID =
            await category.randomizer(public: isPublic);
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
      'name': name,
      'creatorID': ownerID,
      'category': category.name,
      'questionIds': _usedQuestions,
    });
  }

  Future<Quiz> retrieveQuizFromId({required String id}) async {
    print('inside retrieveQuizFromId method. Id: $id');
    this.isPublic = false;

    await firestore
        ?.collection('quizzes')
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      print('it got the collection');
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
        this.name = documentSnapshot['name'];
        this.id = documentSnapshot['id'];
        this.ownerID = documentSnapshot['creatorID'];
        this.category = new Category(name: documentSnapshot['category']!);
        // this.categoryName = ;
        this.noOfQuestions = documentSnapshot['questionIds'].length;

        /// add all questionIds to the list of used questions
        for (int i = 0; i < noOfQuestions; i++) {
          _usedQuestions.add(documentSnapshot['questionIds'][i]);
        }
      } else {
        print('Document does not exist on the database');
      }
    });

    for (int i = 0; i < noOfQuestions; i++) {
      Question tempQuestion =
          await category.getPrivateQuestion(_usedQuestions[i], ownerID!);
      _questions.add(tempQuestion);
    }

    return this;
  }
}
