import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:queasy/src/model/category.dart';
import 'package:queasy/src/model/question.dart';
import 'package:queasy/src/model/quiz.dart';

/// Main function for testing the [Quiz] class.
void main() async {
  final instance = FakeFirebaseFirestore();
  late List<Question> _questions;

  /// Creates question0 for testing: What is the capital of France?
  Map<String, dynamic> question0 = {
    'category': 'geography',
    'ID': 'question0',
    'text': 'What is the capital of France?',
    'answer1': {'text': 'Paris', 'isCorrect': true},
    'answer2': {'text': 'London', 'isCorrect': false},
    'answer3': {'text': 'Berlin', 'isCorrect': false},
    'answer4': {'text': 'Rome', 'isCorrect': false},
  };

  /// Creates question1 for testing: What is the capital of Germany?
  Map<String, dynamic> question1 = {
    'category': 'geography',
    'ID': 'question1',
    'text': 'What is the capital of Germany?',
    'answer1': {'text': 'Paris', 'isCorrect': false},
    'answer2': {'text': 'London', 'isCorrect': false},
    'answer3': {'text': 'Berlin', 'isCorrect': true},
    'answer4': {'text': 'Rome', 'isCorrect': false},
  };

  /// Creates question2 for testing: What is the capital of Italy?
  Map<String, dynamic> question2 = {
    'category': 'geography',
    'ID': 'question2',
    'text': 'What is the capital of Italy?',
    'answer1': {'text': 'Paris', 'isCorrect': false},
    'answer2': {'text': 'London', 'isCorrect': false},
    'answer3': {'text': 'Berlin', 'isCorrect': false},
    'answer4': {'text': 'Rome', 'isCorrect': true},
  };

  /// Creates question3 for testing: What is the capital of Spain?
  Map<String, dynamic> question3 = {
    'category': 'geography',
    'ID': 'question3',
    'text': 'What is the capital of England?',
    'answer1': {'text': 'Paris', 'isCorrect': false},
    'answer2': {'text': 'London', 'isCorrect': true},
    'answer3': {'text': 'Berlin', 'isCorrect': false},
    'answer4': {'text': 'Rome', 'isCorrect': false},
  };

  /// Creates question4 for testing: What is the capital of Spain?
  Map<String, dynamic> question4 = {
    'category': 'geography',
    'ID': 'question4',
    'text': 'What is the capital of Spain?',
    'answer1': {'text': 'Paris', 'isCorrect': false},
    'answer2': {'text': 'London', 'isCorrect': false},
    'answer3': {'text': 'Berlin', 'isCorrect': false},
    'answer4': {'text': 'Rome', 'isCorrect': false},
  };

  /// Pushes question0 into the fake firestore database
  await instance
      .collection('categories')
      .doc('public')
      .collection('geography')
      .doc('question0')
      .set(question0);

  /// Pushes question1 into the fake firestore database
  await instance
      .collection('categories')
      .doc('public')
      .collection('geography')
      .doc('question1')
      .set(question1);

  /// Pushes question2 into the fake firestore database
  await instance
      .collection('categories')
      .doc('public')
      .collection('geography')
      .doc('question2')
      .set(question2);

  /// Pushes question3 into the fake firestore database
  await instance
      .collection('categories')
      .doc('public')
      .collection('geography')
      .doc('question3')
      .set(question3);

  /// Pushes question4 into the fake firestore database
  await instance
      .collection('categories')
      .doc('public')
      .collection('geography')
      .doc('question4')
      .set(question4);

  Category category = Category(name:'geography', firestore: instance);

  /// Initializes the test constructor for the [Quiz] class
  Quiz quiz = Quiz.createRandom(category: category, noOfQuestions: 5, isPublic: true, firestore: instance);

  // await quiz.storeQuiz(instance);
  // print(instance.dump());

  /// Store quiz questions into _questions List for testing
  _questions = quiz.questions;

  group('Tests the quiz model (retrieving questions)', () {
    /// Testing if the amount of questions int the list is the same as in the constructor
    test('Quiz should have a question list with 5 questions', () {
      expect(_questions.length, 5);
    });

    /// Testing if question0 is in the returned list
    test(
        'One of the questions should have the text \'What is the capital of France?\'',
        () {
      expect(
          _questions.any(
              (element) => element.text == 'What is the capital of France?'),
          true);
    });

    /// Testing if question1 is in the returned list
    test(
        'One of the questions should have the text \'What is the capital of Germany?\'',
        () {
      expect(
          _questions.any(
              (element) => element.text == 'What is the capital of Germany?'),
          true);
    });

    ///  Testing if question2 is in the returned list
    test(
        'One of the questions should have the text \'What is the capital of Italy?\'',
        () {
      expect(
          _questions.any(
              (element) => element.text == 'What is the capital of Italy?'),
          true);
    });

    /// Testing if question3 is in the returned list
    test(
        'One of the questions should have the text \'What is the capital of England?\'',
        () {
      expect(
          _questions.any(
              (element) => element.text == 'What is the capital of England?'),
          true);
    });

    /// Testing if question4 is in the returned list
    test(
        'One of the questions should have the text \'What is the capital of Spain?\'',
        () {
      expect(
          _questions.any(
              (element) => element.text == 'What is the capital of Spain?'),
          true);
    });
  });
}
