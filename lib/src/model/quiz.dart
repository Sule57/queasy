import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
import 'package:queasy/src/model/question.dart';
import 'answer.dart';


/// The class [Quiz] represents a playable quiz
/// It consists of multiple variables that need to be correctly parsed in order for the class to be properly initialized
///
/// The variable [id] represents the unique id of a quiz in the database
///
/// The variable [noOfQuestions] represents the amount of questions that the quiz should have and is used to know how many questions to retrieve from the database
///
/// The variable [creatorUsername] defines the username of the person who originally created the quiz
///
/// The static List [_questions] is a private list that stores objects of type Questions, or to be exact, the actual questions of the quiz
///
/// The static list [_usedQuestions] is a private list that stores the indexes of the questions that have already been used in the quiz
///
/// The String variable [category] is a variable that stores the category of the quiz, so on which topic is the quiz
///
/// The variable [_firebaseFirestore] is a private variable that represents an instance of the firebase connection, used to manipulate the firebase database
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

  /// The [initialize] function is used to retrieve the questions from the database and store them in the [_questions] list.
  /// The function takes the [firestore] parameter which is the default firestore instance used to retrieve the previously mentioned questions
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

    await firestore
        .collection('categories')
        .doc(creatorUsername)
        .collection(category)
        .doc(questionId)
        .get()
        .then((DocumentSnapshot doc) {
      data = doc.data() as Map<String, dynamic>;
    });

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

  /// The method [storeQuiz] is used to store the quiz in the database using it's information provided in the general variables
  /// The method takes the [firestore] optional parameter which makes it easier to test the method
  /// If the [firestore] instance is provided the method will use it to store the quiz in the database
  /// If the [firestore] instance is not provided the method will use the default instance to store the quiz in the database
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
