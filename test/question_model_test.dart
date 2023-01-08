import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:queasy/src.dart';

/// Main function for testing the [Question] class. Since the class is not "rich"
/// in methods, this test file will only test the constructor and the .update()
/// method.
void main() async {
  /// The variable instance is used to create a new instance of the mock firebase
  final instance = FakeFirebaseFirestore();

  /// The text variable stores the text of the question.
  String text = 'What is the capital of France?';
  /// The category variable stores the category of the question.
  String category = 'geography';
  /// The ID variable stores the ID of the question.
  String ID = 'question0';
  /// The answer1 variable stores the text of the first answer.
  String answer1 = 'Paris';
  /// The answer2 variable stores the text of the second answer.
  String answer2 = 'London';
  /// The answer3 variable stores the text of the third answer.
  String answer3 = 'Berlin';
  /// The answer4 variable stores the text of the fourth answer.
  String answer4 = 'Rome';
  /// The isCorrect1 variable stores the value of the isCorrect attribute of the
  /// first answer.
  bool isCorrect1 = true;
  /// The isCorrect2 variable stores the value of the isCorrect attribute of the
  /// second answer.
  bool isCorrect2 = false;
  /// The isCorrect3 variable stores the value of the isCorrect attribute of the
  /// third answer.
  bool isCorrect3 = false;
  /// The isCorrect4 variable stores the value of the isCorrect attribute of the
  /// fourth answer.
  bool isCorrect4 = false;
  /// The question0 stores the question that will be used for testing. But also
  /// tests the validity of the constructor.
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

  /// Pushes the question to the mock firebase using the normal firestore functions.
  await instance.collection('categories').doc('test123456789').collection(
      'geography').doc('question0').set(question0.toJson());

  /// The group of tests that will check if the constructor and the .update()
  /// functions work correctly.
  group('Checking question update', () {
    /// Tests if the question was stored into the database by retrieving the
    /// question from the database with the id question0 and checking if it
    /// exists.
    test('Question was stored test', () async {
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

    /// Tests if the question was updated in the firebase to the new values by
    /// retrieving the question0 from the firebase and comparing it to the
    /// new question0 instance.
    test('Question was updated test', () async {
      final question = await instance.collection('categories').doc('test123456789').collection(
          'geography').doc('question0').get();
      expect(question.data(), question0.toJson());
    });

  });

}