import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:queasy/exports/model.dart';
import 'package:queasy/src/model/category.dart';
import 'package:queasy/src/model/question.dart';
import 'package:queasy/src/model/quiz.dart';

// The function fromJSON is tested through retrieveQuizFromID()


/// Main function for testing the [Quiz] class.
void main() async {
  /// The variable instance is used to create a new instance of the mock firebase
  /// firestore.
  final instance = FakeFirebaseFirestore();
  /// The variable _questions is used to store the questions that were initialized
  /// in the quiz1.
  late List<Question> _questions;
  /// The variable _questions2 is used to store the questions that were initialized
  /// in the quiz2.
  late List<Question> _questions2;

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

  await instance
      .collection('categories')
      .doc('public')
      .collection('geography')
      .doc('question0')
      .set(question0);

  await instance
      .collection('categories')
      .doc('public')
      .collection('geography')
      .doc('question1')
      .set(question1);

  await instance
      .collection('categories')
      .doc('public')
      .collection('geography')
      .doc('question2')
      .set(question2);

  await instance
      .collection('categories')
      .doc('public')
      .collection('geography')
      .doc('question3')
      .set(question3);

  await instance
      .collection('categories')
      .doc('public')
      .collection('geography')
      .doc('question4')
      .set(question4);

  /// Creates a new instance of the Category class. The category is initialized
  /// with the name 'geography'.
  Category category = Category(name:'geography', firestore: instance);

  /// Initializes the test constructor for the [Quiz] class with the category
  /// 'geography', the number of questions 5, the isPublic flag set to
  /// true and the name 'testQuiz'.
  Quiz quiz = await Quiz(firestore: instance).getRandomQuestions(category: category, noOfQuestions: 5, isPublic: true, name: 'testQuiz', firestore: instance);

  _questions = quiz.questions;

  await instance
      .collection('categories')
      .doc('test123456789')
      .collection('geography')
      .doc('question0')
      .set(question0);

  await instance
      .collection('categories')
      .doc('test123456789')
      .collection('geography')
      .doc('question1')
      .set(question1);

  await instance
      .collection('categories')
      .doc('test123456789')
      .collection('geography')
      .doc('question2')
      .set(question2);

  await instance
      .collection('categories')
      .doc('test123456789')
      .collection('geography')
      .doc('question3')
      .set(question3);

  await instance
      .collection('categories')
      .doc('test123456789')
      .collection('geography')
      .doc('question4')
      .set(question4);

  /// Creates a quiz0 map that represents a quiz in a Json format.
  Map<String, dynamic> quiz0 = {
    'category': 'geography',
    'id': 'quiz123',
    'creatorID': 'test123456789',
    'name': 'testQuiz',
    'questionIds': ['question0', 'question1', 'question2', 'question3', 'question4'],
  };

  await instance
        .collection('quizzes')
        .doc('quiz123')
        .set(quiz0);

  /// Creates a new instance of Quiz using the retrieveQuiz method, in theory
  /// this method should take the ID of the quiz and retrieve it from the
  /// database. (This will be tested in the next test group).
  Quiz quiz2 = await Quiz(firestore: instance).retrieveQuizFromId(id: 'quiz123', firestore: instance) ;
  _questions2 = quiz2.questions;
  quiz.storeQuiz();

  List<String> questionIds = ['question0', 'question1'];
  Quiz quiz3 = await Quiz(firestore: instance).createCustomQuiz(questions: questionIds, category: category, name: 'testQuiz3', firestore: instance);

  /// Test group that tests if the public quiz was initialized properly from
  /// the previously provided questions.
  group('Tests the public quiz (retrieving questions)', () {
    /// Testing if the amount of questions in the list is the same as in the
    ///       // _quiz = await Quiz.().getRandomQuestions(category: Category(
      //   name: _quizCategory!), noOfQuestions: _totalQuestions, isPublic: true);constructor.
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

    /// Testing if the quiz is stored in the database
    test('Quiz should be stored in the database', () {
      expect(instance.collection('quizzes').doc('quiz123').get(), isNotNull);
    });
  });

    /// Testing if the checkIfQuizExists method works properly
    test('Quiz should exist in the database', () async {
      expect(await Quiz.checkIfQuizExists(id: 'quiz123', firestore: instance), true);
    });

  /// Tests the quiz.retrieveQuizFromId() method works and retrieves the quiz
  /// object as it was in the map.
  group('Tests the private quiz (retrieving questions)', () {
    /// Testing if the amount of questions int the list is the same as in the map.
    test('Quiz should have a question list with 5 questions', () {
      expect(_questions2.length, 5);
    });

    /// Testing if question0 is in the returned list
    test(
        'One of the questions should have the text \'What is the capital of France?\'',
            () {
          expect(
              _questions2.any(
                      (element) => element.text == 'What is the capital of France?'),
              true);
        });

    /// Testing if question1 is in the returned list
    test(
        'One of the questions should have the text \'What is the capital of Germany?\'',
            () {
          expect(
              _questions2.any(
                      (element) => element.text == 'What is the capital of Germany?'),
              true);
        });

    ///  Testing if question2 is in the returned list
    test(
        'One of the questions should have the text \'What is the capital of Italy?\'',
            () {
          expect(
              _questions2.any(
                      (element) => element.text == 'What is the capital of Italy?'),
              true);
        });

    /// Testing if question3 is in the returned list
    test(
        'One of the questions should have the text \'What is the capital of England?\'',
            () {
          expect(
              _questions2.any(
                      (element) => element.text == 'What is the capital of England?'),
              true);
        });

    /// Testing if question4 is in the returned list
    test(
        'One of the questions should have the text \'What is the capital of Spain?\'',
            () {
          expect(
              _questions2.any(
                      (element) => element.text == 'What is the capital of Spain?'),
              true);
        });

    /// Testing if the quiz3 has values in the question list
    test('Quiz3 should have a question list with 2 questions', () {
      expect(quiz3.questions.length, 2);
    });

    /// Checking if the quiz3 has the correct questions
    test('Quiz3 should have the correct questions', () {
      expect(quiz3.questions[0].text, 'What is the capital of France?');
      expect(quiz3.questions[1].text, 'What is the capital of Germany?');

    });

    /// Tests if the updateQuiz function works properly
    test('Quiz should be updated in the database', () async {
      List<String> questionIds = ['question0', 'question1', 'question2'];
      quiz.setUsedQuestions(questionIds);
      await quiz.updateQuiz();
      Quiz quiz4 = await Quiz(firestore: instance).retrieveQuizFromId(id: quiz.id, firestore: instance);
      expect(quiz4.questions.length, 3);
      expect(quiz4.questions[0].text, 'What is the capital of France?');
    });

  });

}
