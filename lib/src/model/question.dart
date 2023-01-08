import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queasy/src/model/profile.dart';
import 'package:queasy/utils/exceptions.dart';
import 'answer.dart';

/// This class represents a question in the quiz, it has direct access to the
/// firebase and is used to store a question or update it in the database.
class Question {
  /// The parameter text represents the actual question, so for instance a
  /// question could look like
  /// What is the capial of France?:
  /// Paris,
  /// London,
  /// Berlin,
  /// Rome.
  /// The text would be "What is the capital of France?".
  String text = "";
  /// The parameter answers is a list of objects of type [Answer] which
  /// represent the possible answers to the question, so in the example given in
  /// the definition of [text] this list would store 4 objects of type [Answer]
  /// with the text "Paris", "London", "Berlin" and "Rome".
  List<Answer> answers = [];
  /// The parameter category represents the category of which this question is,
  /// so for instance if the question is about geography, the category would be
  /// "Geography". This will later be manipulated by a special class Category
  /// which will be responsible for manipulating the questions inside the firebase.
  String category = "";
  /// The parameter questionId is the ID of the question, it is used to identify
  /// the question inside the firebase.
  late String? questionId = "";
  /// The parameter UID is the unique ID of the user who is currently logged in,
  /// but since functions of this class should only be accessible to the user who
  /// created the question, it represents the unique id of the user who created
  /// the question. It is used to know who created the question, and to know where
  /// exactly in the firebase this question should be stored, due to questions by
  /// users being private.
  String? UID;
  /// The late parameter firestore is used to represent an instance of firebase
  /// connection, it is used to manipulate the firebase.
  late FirebaseFirestore? firestore;

  /// The getter for the id of the question.
  get id => questionId;

  /// This is the constructor of the class, it's used to create a new instance
  /// of the class, it takes the parameters [text], [answers], [category] and
  /// optionally [questionId] and [firestore].
  /// The optional parameter [questionId] is used when the id is known, because
  /// the question already exists in the firebase.
  /// The optional parameter [firestore] is used for testing purposes, if it is
  /// passed the constructor will assume that the developer is in testing.
  /// Therefore the [UID] will be set to a default value. If it is not passed
  /// the constructor will assume that the developer is not in testing, and
  /// therefore the [UID] will be set to the value of the currently logged in
  /// user, and [firestore] will be set to a new connection instance to the
  /// real firebase.
  Question(
      {required this.text,
        required this.answers,
        required this.category,
        this.questionId,
        firestore}) {
    if (firestore == null) {
      firestore = FirebaseFirestore.instance;
      UID = getCurrentUserID();
    }
    else {
      this.firestore = firestore;
      UID = "test123456789";
    }
  }

  /// Question.fromJson is a constructor that takes a [json] object as a
  /// parameter and creates a new instance of the class [Question] from it.
  /// Since, the questions in the firebase do not contain a category, the
  /// constructor will take a parameter [category] which will be used to set
  /// the category of the question.
  Question.fromJson(Map<String, dynamic> json, String category) {
    this.answers.add(Answer.fromJson(json['answer1']));
    this.answers.add(Answer.fromJson(json['answer2']));
    this.answers.add(Answer.fromJson(json['answer3']));
    this.answers.add(Answer.fromJson(json['answer4']));
    this.text = json['text'];
    this.questionId = json['ID'];
    this.category = category;
  }

  /// The [getText] method is used to retrieve the text of a Question object.
  String getText() {
    return text;
  }

  /// Sets the local text of the question to the value of the parameter [text].
  void setText(String text) {
    this.text = text;
  }

  /// Returns the answer at the index [index] of the list of answers.
  Answer getAnswer(int index) {
    return answers[index];
  }

  /// Sets the answer in the list of answers at the index [index] to the value
  /// of the parameter [answer] which is of type [Answer].
  void setAnswer(int index, Answer answer) {
    answers[index] = answer;
  }

  /// Sets the correct answer to the one at the index [index] of the list of
  /// answers. It does this by setting the correct answer of the answer at the
  /// index [index] to true. It also sets the correct answer of all the other
  /// answers to false, because there is supposed to be only one correct answer.
  void setCorrectAnswer(int index) {
    for (int i = 0; i < answers.length; i++) {
      if (i == index) {
        answers[i].setCorrect(true);
      } else {
        answers[i].setCorrect(false);
      }
    }
  }

  /// Updates the question in firebase by using the [firestore] instance. It
  /// finds the question at the id of [id] and updates it with the values of
  /// the current instance of the class.
  ///
  /// The way this class would be used is, after retrieval of an already
  /// existing question from the firebase and storing it to an instance of type
  /// [Question], the user would change the local values of the instance and
  /// then call this function to update the question in the firebase.
  ///
  /// The function also contains a check, if the [UID] is null, which would
  /// mean that a user is not logged in, and therefore the function would throw
  /// a [UserNotLoggedInException].
  Future<void> updateQuestion({String? uid}) async {

    if (uid != null) {
      UID = uid;
    }
    if (UID == null) {
      throw UserNotLoggedInException();
    }

    await firestore
        ?.collection('categories')
        .doc(UID)
        .collection(category)
        .doc(questionId)
        .update({
      'category': category,
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

  /// Returns a map of the question, which can be used to store the question
  /// in the firebase.
  Map<String, dynamic> toJson() {
    return {
      'ID': questionId,
      'category': category,
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
    };
  }
}
