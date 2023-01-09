import 'dart:ui';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:queasy/src.dart';
import 'package:queasy/src/model/category.dart';
import 'package:queasy/src/model/category_repo.dart';
import 'package:queasy/src/model/quiz.dart';

/// Main function for testing the [Category] class.
///
/// [instance] is the Fake Firestore instance for mocking of the database
///
/// [catName] is the name of the category
///
/// [UID] is the UID of the user
///
/// [color] is the color of the category
///
/// [username] is the username of the user
void main() async {
  String catName = 'German';
  Color color = Color(12423);
  String UID = 'uid1';
  String username = 'Savo';

  var instance = FakeFirebaseFirestore();

  await instance.collection('categories').doc('public').set({});
  await instance.collection('categories').doc(UID).set({});


  await CategoryRepo(instance_: instance, id: UID).createCategory(catName, color, instance: instance, uid: UID, username_: username);

  Category cat = await Category(name: catName, color:color, firestore:instance, UID: UID);
  test('Category is not created properly', () {
    expect({cat.getName(), cat.getColor(), cat.UID}, {catName, color, UID});
  });


  test('Category color is not set properly', () async {
    Color newColor = Color(123);
    await cat.setColor(newColor);

    cat = await CategoryRepo(instance_: instance, id: UID).getCategory(catName, instance: instance, uid: UID, username_: username);
    expect(cat.getColor(), newColor);
  });


  test('Category name is not set properly', () async {
    String newName = 'English';

    await cat.changeNameOfCategory(newName);
    cat = await CategoryRepo(instance_: instance, id: UID).getCategory(newName, instance: instance, uid: UID, username_: username);

    expect(cat.getName(), newName);
  });

  test('Questions are not added', () async {
    String newName = 'English';
    Question q1 = Question(UID: UID, category: newName, text: 'Question1', answers: [Answer('asnwer1', true), Answer('asnwer2', true), Answer('asnwer3', true), Answer('asnwer4', true)], firestore: instance);
    Question q2 = Question(UID: UID, category: newName, text: 'Question2', answers: [Answer('asnwer1', true), Answer('asnwer2', true), Answer('asnwer3', true), Answer('asnwer4', true)], firestore: instance);
    Question q3 = Question(UID: UID, category: newName, text: 'Question3', answers: [Answer('asnwer1', true), Answer('asnwer2', true), Answer('asnwer3', true), Answer('asnwer4', true)], firestore: instance);
    await cat.createQuestion(q1);
    await cat.createQuestion(q2);
    await cat.createQuestion(q3);

    List<Question> list = await cat.getAllQuestions();
    expect(list.length, 3);
  });


  test('Question is not deleted', () async {
    List<Question> list = await cat.getAllQuestions();
    Question q = list.firstWhere((element) => element.questionId == 'question0');
    cat.deleteQuestion(q);

    list = await cat.getAllQuestions();
    q = list.firstWhere((element) => element.questionId == 'question1');
    cat.deleteQuestion(q);
    list = await cat.getAllQuestions();
    expect(list.length, 1);
  });


  test('Question is not edited', () async {
    List<Question> list = await cat.getAllQuestions();
    Question question0 = list.firstWhere((element) => element.questionId == 'question2');


    question0.text = 'What is the capital of Germany?';
    question0.answers[0].setText('Berlin');
    question0.answers[0].setCorrect(true);
    question0.answers[1].setText('Paris');
    question0.answers[1].setCorrect(false);
    question0.answers[2].setText('London');
    question0.answers[2].setCorrect(false);
    question0.answers[3].setText('Rome');
    question0.answers[3].setCorrect(false);
    await question0.updateQuestion(uid: UID, instance: instance);

    list = await cat.getAllQuestions();
    question0 = list.firstWhere((element) => element.questionId == 'question2');


    expect(question0.getText(), 'What is the capital of Germany?');
    expect({question0.getAnswer(0).text, question0.getAnswer(0).isCorrect}, {'Berlin', true});
    expect({question0.getAnswer(1).text, question0.getAnswer(1).isCorrect}, {'Paris', false});
    expect({question0.getAnswer(2).text, question0.getAnswer(2).isCorrect}, {'London', false});
    expect({question0.getAnswer(3).text, question0.getAnswer(3).isCorrect}, {'Rome', false});
  });



}
