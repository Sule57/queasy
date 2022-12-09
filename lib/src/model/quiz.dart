import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
import 'package:queasy/src/model/question.dart';
import 'answer.dart';

class Quiz {
  int id, noOfQuestions;
  String creatorUsername;
  static List<Question> _questions = [];
  static List<String> _usedQuestions = [];
  String category;
  late FirebaseFirestore _firebaseFirestore;

  /// The default onstructor for the [Quiz] class.
  ///
  /// This class takes the given parameters to create an instance of class [Quiz]
  /// The [id] parameter represents the unique id of the quiz.
  /// The function initialize will run inside of this constructor taking the parameters [noOfQuestions] and [category] to retrieve the questions from firebase in order to create the quiz.
  /// The [creatorUsername] parameter represents the username of the creator of the quiz. (PlayerUsername is to be implemented)
  Quiz.normal({
    required this.id,
    required this.creatorUsername,
    required this.noOfQuestions,
    required this.category,
  }) {
    _firebaseFirestore = FirebaseFirestore.instance;
    initialize(_firebaseFirestore);
  }

  /// The testing constructor for the [Quiz] class.
  ///
  /// This class takes the given parameters to create an instance of class [Quiz]
  /// The [id] parameter represents the unique id of the quiz.
  /// The function initialize will run inside of this constructor taking the parameters [noOfQuestions] and [category] to retrieve the questions from firebase in order to create the quiz.
  /// The [creatorUsername] parameter represents the username of the creator of the quiz. (PlayerUsername is to be implemented)
  /// The [firestore] parameter represents the firestore instance to be used for testing (a.k.a. Mock firebase).
  /// This constructor is used for testing purposes only.
  Quiz.test({
    required this.id,
    required this.creatorUsername,
    required this.noOfQuestions,
    required this.category,
    required FirebaseFirestore firestore,
  }) {
    initialize(firestore);
  }

  /// Initializes the quiz
  ///
  /// Uses the [firestore] instance to get the questions from the database and adds them to the [_questions] list.
  Future<void> initialize(FirebaseFirestore firestore) async {
    for (int i = 0; i < noOfQuestions; i++) {
      String questionId = "question${await randomizer(category, firestore)}";
      if (_usedQuestions.contains(questionId)) {
        i--;
      } else {
        _usedQuestions.add(questionId);
        await getQuestion(category, questionId, firestore).then((value) {
          _questions.add(value);
        });
      }
    }
  }

  /// Retrives a question from firebase
  ///
  /// Firebase is accessed through the [firestore] instance.
  /// Then the question is retrieved from the database from the given [category] and randomly generated [questionId].
  /// And lastly the question is returned
  Future<Question> getQuestion(
      category, questionId, FirebaseFirestore firestore) async {
    Map<String, dynamic>? data;

    // Access the database and get the question
    await firestore
        .collection('categories')
        .doc(creatorUsername)
        .collection(category)
        .doc(questionId)
        .get()
        .then((DocumentSnapshot doc) {
      data = doc.data() as Map<String, dynamic>;
    });

    // Create an instance of Question
    Question question = Question(
      text: data!['text'],
      answers: [
        Answer(data!['answer1']['text'], data!['answer1']['isCorrect']),
        Answer(data!['answer2']['text'], data!['answer2']['isCorrect']),
        Answer(data!['answer3']['text'], data!['answer3']['isCorrect']),
        Answer(data!['answer4']['text'], data!['answer4']['isCorrect']),
      ],
      category: category,
      questionID: questionId,
      owner: creatorUsername,
    );
    return question;
  }

  /// Creates a random number between 0 and amount of questions in the category
  ///
  /// The database is accessed through the [firestore] instance and the documents
  /// under the given [category] are counted and the random number is generated
  Future<int> randomizer(category, FirebaseFirestore firestore) async {
    /// Stores the current number of questions in the category
    var numOfQuestions = await firestore
        .collection('categories')
        .doc('public')
        .collection(category)
        .get()
        .then((value) => value.docs.length);

    if (numOfQuestions == 0) {
      return 0;
    } else {
      return Random().nextInt(numOfQuestions);
    }
  }

  /// Returns the list of questions generated for a particular quiz so public access can be achieved
  List<Question> getQuestions() {
    return _questions;
  }

  Future<void> storeQuiz(FirebaseFirestore? firebaseFirestore) async {

    if (firebaseFirestore == null) {
      firebaseFirestore = FirebaseFirestore.instance;
    }

    /// count the amount of quizzes in the database
    var numOfQuizzes = await firebaseFirestore
        .collection('quizzes')
        .doc(creatorUsername)
        .collection('myQuizzes')
        .get()
        .then((value) => value.docs.length);

    String quizId = "quiz$numOfQuizzes";

    // Check if the quiz already exists, if it does numofquizzes is incremented and the quizId is updated
    while (await firebaseFirestore
        .collection('quizzes')
        .doc(creatorUsername)
        .collection('myQuizzes')
        .doc(quizId)
        .get()
        .then((value) => value.exists)) {
      numOfQuizzes++;
      quizId = "quiz$numOfQuizzes";
    }

    // Store the quiz in the database
    await firebaseFirestore
        .collection('quizzes')
        .doc(creatorUsername)
        .collection('myQuizzes')
        .doc(quizId)
        .set({
      'id': quizId,
      'creatorUsername': creatorUsername,
      'noOfQuestions': noOfQuestions,
      'category': category,
      'questions': {
        for (int i = 0; i < _questions.length; i++){
          'question$i': _usedQuestions[i],
        }
      }
    });
  }

}
