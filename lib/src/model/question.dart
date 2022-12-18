import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:queasy/src/model/profile.dart';
import 'answer.dart';

/// This class represents a question in the quiz, it has direct access to the firebase and is used to manipulate questions inside the firebase (for now, later category will do this)
///
/// The parameter [text] represents the actual question, so for instance a question could look like
/// What is the capial of France?
/// Paris
/// London
/// Berlin
/// Rome
/// the text would be "What is the capital of France?"
///
/// The parameter [answers] is a list of objects of type [Answer] which represent the possible answers to the question,
/// so in the previously given example this list would store 4 objects of type [Answer] with the text "Paris", "London", "Berlin" and "Rome"
///
/// The parameter [category] represents the category of which this question is, so for instance if the question is about geography, the category would be "Geography"
/// This will later be manipulated by a special class Category which will be responsible for manipulating the questions inside the firebase
///
/// The parameter [questionID] is the ID of the question, it is used to identify the question inside the firebase
///
/// The parameter [owner] is the username of the user who created the question, it is used to identify the user who created the question,
/// and to know where exactly in the firebase this question should be stored, due to questions by users being private
///
/// The late parameter [firestore] is used to represent an instance of firebase connection, it is used to manipulate the firebase
class Question {
  String text = "";
  List<Answer> answers = [];
  String category = "";
  String? questionID = "";


  /// This is the constructor of the class, it takes the text of the question, the list of answers, the category of the question the ID of the question and the owner of the question as parameters
  /// and assigns them to the corresponding parameters of the class
  Question({
    required this.text,
    required this.answers,
    required this.category,
    required this.questionID,
  });

  /// Question.fromJson is a constructor used to initialize an object of type [Question] from a json object,
  /// these objects are usually provided by firebase, so to retrieve a question, this would be the most optimal way to do it
  Question.fromJson(Map<String, dynamic> json){
    answers.add(Answer.fromJson(json['answer1']));
    answers.add(Answer.fromJson(json['answer2']));
    answers.add(Answer.fromJson(json['answer3']));
    answers.add(Answer.fromJson(json['answer4']));
    text = json['text'];
    questionID = json['ID'];
  }

  /// The [getText] method is used to retrieve the text of a Question object
  String getText() {
    return text;
  }

  /// setter for the text of the question
  void setText(String text) {
    this.text = text;
  }

  get ID => questionID;

  /// The [getAnswer] method is used to retrieve an answer from the list of answers of a Question object, it takes the index of the answer as a parameter
  Answer getAnswer(int index) {
    return answers[index];
  }

  void setCorrectAnswer(int index) {
    for (int i = 0; i < answers.length; i++) {
      if (i == index) {
        answers[i].setCorrect(true);
      } else {
        answers[i].setCorrect(false);
      }
    }
  }

  /// updateQuestion function takes all the parameters of the question and updates the question in the firebase as a json
  /// this function is used to update the question in the firebase
  Future<void> updateQuestion(FirebaseFirestore? firestore) async {

    if(firestore == null){
      firestore = FirebaseFirestore.instance;
    }

    await firestore
        .collection('categories')
        .doc(getCurrentUserID())
        .collection(category)
        .doc(questionID)
        .update({
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

  /// turns the question into a json object
  Map<String, dynamic> toJson() {
    return {
      'ID': questionID,
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
