import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queasy/model/question.dart';
import 'answer.dart';

class Quiz {
  /// @param questions The list of questions in the quiz
  /// @param usedQuestions The list of questions that have already been used
  /// @param firebaseFirestore The instance of the firebase firestore
  int id, noOfQuestions;
  String? creatorUsername;
  static List<Question> _questions = [];
  static List<String> _usedQuestions = [];
  String category;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  /// Constructor for the Quiz class (Automatically calls the initialize method)
  /// @param id The id of the quiz
  /// @param creatorUsername The username of the creator of the quiz
  /// @param noOfQuestions The number of questions in the quiz
  /// @param category The category of the quiz
  Quiz({
    required this.id,
    this.creatorUsername,
    required this.noOfQuestions,
    required this.category,
  }) {
    initialize();
  }

  /// Initializes the quiz by getting the questions from the database and adding them to the questions list
  void initialize() async {
    for (int i = 0; i < noOfQuestions; i++) {
      String questionId = "question${await randomizer(category)}";
      if (_usedQuestions.contains(questionId)) {
        i--;
      } else {
        _usedQuestions.add(questionId);
        await getQuestion(category, questionId, firebaseFirestore)
            .then((value) {
          _questions.add(value);
        });
      }
    }
  }

  /// Gets a question from the database
  /// @param category The category of the question
  /// @param questionId The id of the question
  /// @param firebaseFirestore The instance of the firebase firestore
  /// @return The question
  Future<Question> getQuestion(
      category, questionId, FirebaseFirestore firebaseFirestore) async {
    /// The question that will be returned
    Map<String, dynamic>? data;

    /// The document reference of the question (Database Access)
    await firebaseFirestore
        .collection('categories')
        .doc('public')
        .collection(category)
        .doc(questionId)
        .get()
        .then((DocumentSnapshot doc) {
      data = doc.data() as Map<String, dynamic>;
    });

    /// The question text & answers stored
    Question question = Question(
      text: data!['text'],
      answers: [
        Answer(data!['answer1']['text'], data!['answer1']['isCorrect']),
        Answer(data!['answer2']['text'], data!['answer2']['isCorrect']),
        Answer(data!['answer3']['text'], data!['answer3']['isCorrect']),
        Answer(data!['answer4']['text'], data!['answer4']['isCorrect']),
      ],
      // category: category,
    );
    return question;
  }

  /// Generates a random number between 0 and the current number of questions in the category for the question ID
  Future<int> randomizer(category) async {
    /// Stores the current number of questions in the category
    var numOfQuestions = await firebaseFirestore
        .collection('categories')
        .doc('public')
        .collection(category)
        .get()
        .then((value) => value.docs.length);

    Random random = Random();
    int randomNumber = random.nextInt(numOfQuestions);
    return randomNumber;
  }

  /// Gets the list of questions
  List<Question> getQuestions() {
    return _questions;
  }
}
