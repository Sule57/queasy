import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/answer.dart';
import '../model/question.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
late List<int> parsedQuestionIds;

getQuestion (category, questionId) async {
  Map<String, dynamic>? data;

  await firebaseFirestore.collection('categories')
      .doc('public')
      .collection(category)
      .doc(questionId).get().then(
          (DocumentSnapshot doc){
        data = doc.data() as Map<String, dynamic>;
      });

  print (data);
  Question question = Question(data!['text'], [
    Answer(data!['Answer0']['text'], data!['Answer0']['isCorrect']),
    Answer(data!['Answer1']['text'], data!['Answer1']['isCorrect']),
    Answer(data!['Answer2']['text'], data!['Answer2']['isCorrect']),
    Answer(data!['Answer3']['text'], data!['Answer3']['isCorrect']),
  ]);
  return question;
}

randomizer(category) async {
  var numOfQuestions = await firebaseFirestore
      .collection('categories')
      .doc('public')
      .collection(category)
      .get()
      .then((value) => value.docs.length);
  return Random().nextInt(numOfQuestions-1);
}