import 'package:cloud_firestore/cloud_firestore.dart';
import 'answer.dart';


class Question {
  String text = "";
  List<Answer> answers = [];
  String category = "";
  String questionID = "";
  String owner = "";
  late FirebaseFirestore firestore;

  Question({
    required this.text,
    required this.answers,
    required this.category,
    required this.questionID,
    required this.owner,
  });

  Question.fromJson(Map<String, dynamic> json){
    answers.add(Answer.fromJson(json['answer1']));
    answers.add(Answer.fromJson(json['answer2']));
    answers.add(Answer.fromJson(json['answer3']));
    answers.add(Answer.fromJson(json['answer4']));
    text = json['text'];
  }

  String getText() {
    return text;
  }

  Answer getAnswer(int index) {
    return answers[index];
  }

/// edits the question text locally and in firebase
  void editQuestionText(String newText, FirebaseFirestore? firestore) {
    if (firestore == null) {
      firestore = FirebaseFirestore.instance;
    }
    text = newText;
    firestore.collection('categories')
        .doc(owner)
        .collection(category)
        .doc(questionID)
        .update({
      'text': newText,
    });
    firestore.terminate();
  }

  void editAnswerText(int index, String newText, FirebaseFirestore? firestore) {
    if (firestore == null) {
      firestore = FirebaseFirestore.instance;
    }
    answers[index].setText(newText);
    firestore.collection('categories')
        .doc(owner)
        .collection(category)
        .doc(questionID)
        .update({
      'answer${index + 1}': {
        'text': newText,
        'isCorrect': answers[index].isCorrect,
      },
    });
    firestore.terminate();
  }

  /// Sets the given answer as correct and all others to incorrect
  void setCorrectAnswer (int index, FirebaseFirestore? firestore) {
    if (firestore == null) {
      firestore = FirebaseFirestore.instance;
    }
    for (int i = 0; i < answers.length; i++) {
      if (i == index) {
        answers[i].setCorrect(true);
      } else {
        answers[i].setCorrect(false);
      }
    }
    firestore.collection('categories')
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
    firestore.terminate();
  }

  /// Deletes the question from firebase
  void deleteQuestion(FirebaseFirestore? firestore) {
    if (firestore == null) {
      firestore = FirebaseFirestore.instance;
    }
    firestore.collection('categories')
        .doc(owner)
        .collection(category)
        .doc(questionID)
        .delete();
    firestore.terminate();
  }

  /// Checks if the question id already exists in firebase, if not it adds a new question
  void addQuestion(FirebaseFirestore? firestore) {
    if (firestore == null) {
      firestore = FirebaseFirestore.instance;
    }
    firestore.collection('categories')
        .doc(owner)
        .collection(category)
        .doc(questionID)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        print('Question id already exists');
      } else {
        firestore?.collection('categories')
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
    firestore.terminate();
  }
}
