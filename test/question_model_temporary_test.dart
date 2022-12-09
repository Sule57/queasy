import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:queasy/src/model/answer.dart';
import 'package:queasy/src/model/question.dart';

/// Main function for testing the [Quiz] class.
void main() async {
  final instance = FakeFirebaseFirestore();

  /// Creates question0 for testing: What is the capital of France?
  Map<String, dynamic> question0 = {
    'text': 'What is the capital of France?',
    'answer1': {'text': 'Paris', 'isCorrect': true},
    'answer2': {'text': 'London', 'isCorrect': false},
    'answer3': {'text': 'Berlin', 'isCorrect': false},
    'answer4': {'text': 'Rome', 'isCorrect': false},
  };

  /// Creates question1 for testing: What is the capital of Germany?
  Map<String, dynamic> question1 = {
    'text': 'What is the capital of Germany?',
    'answer1': {'text': 'Paris', 'isCorrect': false},
    'answer2': {'text': 'London', 'isCorrect': false},
    'answer3': {'text': 'Berlin', 'isCorrect': true},
    'answer4': {'text': 'Rome', 'isCorrect': false},
  };

  /// Creates question2 for testing: What is the capital of Italy?
  Map<String, dynamic> question2 = {
    'text': 'What is the capital of Italy?',
    'answer1': {'text': 'Paris', 'isCorrect': false},
    'answer2': {'text': 'London', 'isCorrect': false},
    'answer3': {'text': 'Berlin', 'isCorrect': false},
    'answer4': {'text': 'Rome', 'isCorrect': true},
  };

  /// Creates question3 for testing: What is the capital of Spain?
  Map<String, dynamic> question3 = {
    'text': 'What is the capital of England?',
    'answer1': {'text': 'Paris', 'isCorrect': false},
    'answer2': {'text': 'London', 'isCorrect': true},
    'answer3': {'text': 'Berlin', 'isCorrect': false},
    'answer4': {'text': 'Rome', 'isCorrect': false},
  };

  /// Creates question4 for testing: What is the capital of Spain?
  Map<String, dynamic> question4 = {
    'text': 'What is the capital of Spain?',
    'answer1': {'text': 'Paris', 'isCorrect': false},
    'answer2': {'text': 'London', 'isCorrect': false},
    'answer3': {'text': 'Berlin', 'isCorrect': false},
    'answer4': {'text': 'Rome', 'isCorrect': false},
  };

  /// Pushes question0 into the fake firestore database
  await instance
      .collection('categories')
      .doc('test')
      .collection('testing')
      .doc('question0')
      .set(question0);

  /// Pushes question1 into the fake firestore database
  await instance
      .collection('categories')
      .doc('test')
      .collection('testing')
      .doc('question1')
      .set(question1);

  /// Pushes question2 into the fake firestore database
  await instance
      .collection('categories')
      .doc('test')
      .collection('testing')
      .doc('question2')
      .set(question2);

  /// Pushes question3 into the fake firestore database
  await instance
      .collection('categories')
      .doc('test')
      .collection('testing')
      .doc('question3')
      .set(question3);

  /// Pushes question4 into the fake firestore database
  await instance
      .collection('categories')
      .doc('test')
      .collection('testing')
      .doc('question4')
      .set(question4);

  Question testQuestion = Question(text: 'What is the Capital of the US?', answers: [
    Answer('Washington DC', true),
    Answer('New York', false),
    Answer('Los Angeles', false),
    Answer('Chicago', false),
  ], category: 'testing', questionID: 'question3', owner: 'test');

  await testQuestion.addQuestion(instance);

  group('testing of the question.dart functions for firebase', () {

    /// Check if the question was added to the database
    test('Testing the addQuestion function', ()
    {
      expect(
          instance.collection('categories').doc('test').collection('testing').doc(
              'question5').get(), completion(isNotNull));
    });

    // test if the editQuestion function works
    test('Testing the editQuestion function', () async {
      await testQuestion.editQuestionText('lmao123', instance);

      expect(
          instance
              .collection('categories')
              .doc('test')
              .collection('testing')
              .doc('question3')
              .get()
              .then((value) => value.data()!['text']),
          completion('lmao123'));
    });

    // test the set corect answer function
    test('Testing the setCorrectAnswer function', () async {
      await testQuestion.setCorrectAnswer(1, instance);
      expect(testQuestion.answers[1].isCorrect, true);

      print(instance.dump());

      /// Check if the isCorrect field of answer 2 in question3 is true in the database
      expect(
          instance
              .collection('categories')
              .doc('test')
              .collection('testing')
              .doc('question3')
              .get()
              .then((value) => value.data()!['answer2']['isCorrect']),
          completion(true));
    });

    // test the editAnswerText function
    test('Testing the editAnswerText function', () async {
      await testQuestion.editAnswerText(1, 'lmao123', instance);

      expect(testQuestion.answers[1].text, 'lmao123');

      /// Check if the text of answer 2 in question3 is 'lmao123' in the database
      expect(
          instance
              .collection('categories')
              .doc('test')
              .collection('testing')
              .doc('question3')
              .get()
              .then((value) => value.data()!['answer2']['text']),
          completion('lmao123'));
    });

  });
}
