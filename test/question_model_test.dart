import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:queasy/src.dart';

/// Main function for testing the [Quiz] class.
void main() async {
  final instance = FakeFirebaseFirestore();

  String text = 'What is the capital of France?';
  String category = 'geography';
  String ID = 'question0';
  String answer1 = 'Paris';
  String answer2 = 'London';
  String answer3 = 'Berlin';
  String answer4 = 'Rome';
  bool isCorrect1 = true;
  bool isCorrect2 = false;
  bool isCorrect3 = false;
  bool isCorrect4 = false;
  Question question0 = Question(
    text: text,
    category: category,
    answers: [
      Answer(answer1,isCorrect1),
      Answer(answer2,isCorrect2),
      Answer(answer3,isCorrect3),
      Answer(answer4,isCorrect4),
    ],
    questionId: ID,
    firestore: instance,
  );

  await instance.collection('categories').doc('test123456789').collection(
      'geography').doc('question0').set(question0.toJson());

  group('Checking question update', () {
    /// Tests if the question was stored into the database.
    test('Question was stored', () async {
      final question = await instance.collection('categories').doc('test123456789').collection(
          'geography').doc('question0').get();
      expect(question.exists, true);
    });

    question0.text = 'What is the capital of Germany?';
    question0.answers[0].setText('Berlin');
    question0.answers[0].setCorrect(true);
    question0.answers[1].setText('Paris');
    question0.answers[1].setCorrect(false);
    question0.answers[2].setText('London');
    question0.answers[2].setCorrect(false);
    question0.answers[3].setText('Rome');
    question0.answers[3].setCorrect(false);
    question0.updateQuestion();

    /// turn question0 toJson using the method, and compare it to the one in the database
    /// if they are the same, then the update was successful
    /// if they are not the same, then the update was unsuccessful
    test('Question was updated', () async {
      final question = await instance.collection('categories').doc('test123456789').collection(
          'geography').doc('question0').get();
      expect(question.data(), question0.toJson());
    });

  });

}