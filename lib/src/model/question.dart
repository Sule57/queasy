import 'package:cloud_firestore/cloud_firestore.dart';

import 'answer.dart';

class Question {
  String text;
  final List<Answer> answers;
  String category;
  String questionID;
  String owner;
  late FirebaseFirestore _firebaseFirestore;

  Question({
    required this.text,
    required this.answers,
    required this.category,
    required this.questionID,
    required this.owner,
  });

  String getText() {
    return text;
  }

  Answer getAnswer(int index) {
    return answers[index];
  }

/// edits the question text locally and in firebase
  void editQuestionText(String newText) {
    _firebaseFirestore = FirebaseFirestore.instance;
    text = newText;
    _firebaseFirestore.collection('categories')
        .doc(owner)
        .collection(category)
        .doc(questionID)
        .update({
      'text': newText,
    });
  }

  void editAnswerText(int index, String newText) {
    answers[index].setText(newText);
    _firebaseFirestore.collection('categories')
        .doc(owner)
        .collection(category)
        .doc(questionID)
        .update({
      'answer${index + 1}': {
        'text': newText,
        'isCorrect': answers[index].isCorrect,
      },
    });
  }

  /// Sets the given answer as correct and all others to incorrect
  void setCorrectAnswer (int index) {
    for (int i = 0; i < answers.length; i++) {
      if (i == index) {
        answers[i].setCorrect(true);
      } else {
        answers[i].setCorrect(false);
      }
    }
    _firebaseFirestore.collection('categories')
        .doc(owner)
        .collection(category)
        .doc(questionID)
        .update({
      'answer1': {
        'text': answers[0].text,
        'isCorrect': answers[0].isCorrect,
      },
      'answer2': {
        'text': answers[1].text,
        'isCorrect': answers[1].isCorrect,
      },
      'answer3': {
        'text': answers[2].text,
        'isCorrect': answers[2].isCorrect,
      },
      'answer4': {
        'text': answers[3].text,
        'isCorrect': answers[3].isCorrect,
      },
    });
  }

  /// Deletes the question from firebase
  void deleteQuestion() {
    _firebaseFirestore.collection('categories')
        .doc(owner)
        .collection(category)
        .doc(questionID)
        .delete();
  }

  /// Checks if the question id already exists in firebase, if not it adds a new question
  void addQuestion() {
    _firebaseFirestore.collection('categories')
        .doc(owner)
        .collection(category)
        .doc(questionID)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        print('Question id already exists');
      } else {
        _firebaseFirestore.collection('categories')
            .doc(owner)
            .collection(category)
            .doc(questionID)
            .set({
          'text': text,
          'answer1': {
            'text': answers[0].text,
            'isCorrect': answers[0].isCorrect,
          },
          'answer2': {
            'text': answers[1].text,
            'isCorrect': answers[1].isCorrect,
          },
          'answer3': {
            'text': answers[2].text,
            'isCorrect': answers[2].isCorrect,
          },
          'answer4': {
            'text': answers[3].text,
            'isCorrect': answers[3].isCorrect,
          },
        });
      }
    });
  }
}
