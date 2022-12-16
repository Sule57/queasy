import 'package:cloud_firestore/cloud_firestore.dart';
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
  String questionID = "";
  String owner = "";
  late FirebaseFirestore firestore;

  /// This is the constructor of the class, it takes the text of the question, the list of answers, the category of the question the ID of the question and the owner of the question as parameters
  /// and assigns them to the corresponding parameters of the class
  Question({
    required this.text,
    required this.answers,
    required this.category,
    required this.questionID,
    required this.owner,
  });

  /// Question.fromJson is a constructor used to initialize an object of type [Question] from a json object,
  /// these objects are usually provided by firebase, so to retrieve a question, this would be the most optimal way to do it
  Question.fromJson(Map<String, dynamic> json){
    answers.add(Answer.fromJson(json['answer1']));
    answers.add(Answer.fromJson(json['answer2']));
    answers.add(Answer.fromJson(json['answer3']));
    answers.add(Answer.fromJson(json['answer4']));
    text = json['text'];
  }

  /// The [getText] method is used to retrieve the text of a Question object
  String getText() {
    return text;
  }

  /// The [getAnswer] method is used to retrieve an answer from the list of answers of a Question object, it takes the index of the answer as a parameter
  Answer getAnswer(int index) {
    return answers[index];
  }

  /// The [editQuestionText] method is used to edit the text of a Question object, both locally and in firebase
  /// it takes a parameter of type String [newText] which represents the new text to be set to the question
  /// This method also takes a firestore instance [firestore] as an optional parameter, if it is not provided, it will use the default firestore instance of the class,
  /// this makes testing easier since a firestore mock instance can be provided instead of the real one
  Future<void> editQuestionText(String newText, FirebaseFirestore? firestore) async{
    if (firestore == null) {
      firestore = FirebaseFirestore.instance;
    }
    text = newText;
    await firestore.collection('categories')
        .doc(owner)
        .collection(category)
        .doc(questionID)
        .update({
      'text': newText,
    });
  }

  /// The [editAnswerText] method is used to edit the text of an answer of a Question object, both locally and in firebase
  /// it takes a parameter of type String [newText] which represents the new text to be set to the answer
  /// it also takes a parameter of type int [index] which represents the index of the answer to be edited
  /// This method also takes a firestore instance [firestore] as an optional parameter, if it is not provided, it will use the default firestore instance of the class,
  /// this makes testing easier since a firestore mock instance can be provided instead of the real one.
  Future<void> editAnswerText(int index, String newText, FirebaseFirestore? firestore) async{
    if (firestore == null) {
      firestore = FirebaseFirestore.instance;
    }
    answers[index].setText(newText);
    await firestore.collection('categories')
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

  /// The [setCorrectAnswer] method is used to set an answer as correct, both locally and in firebase
  /// when this method is called, and an answer is set to correct, all the other answers from the list will be set to incorrect, again, both locally and in firebase
  /// it takes a parameter of type int [index] which represents the index of the answer to be set to correct
  /// This method also takes a firestore instance [firestore] as an optional parameter, if it is not provided, it will use the default firestore instance of the class,
  Future<void> setCorrectAnswer (int index, FirebaseFirestore? firestore) async{
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
    await firestore.collection('categories')
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

  /// The [deleteQuestion] method is used to remove a question from firebase
  /// it takes a firestore instance [firestore] as an optional parameter, if it is not provided, it will use the default firestore instance of the class,
  /// this makes testing easier since a firestore mock instance can be provided instead of the real one.
  Future<void> deleteQuestion(FirebaseFirestore? firestore) async{
    if (firestore == null) {
      firestore = FirebaseFirestore.instance;
    }
    await firestore.collection('categories')
        .doc(owner)
        .collection(category)
        .doc(questionID)
        .delete();
  }

  /// The [addQuestion] method is used to add a question to firebase
  /// it takes a firestore instance [firestore] as an optional parameter, if it is not provided, it will use the default firestore instance of the class,
  /// this makes testing easier since a firestore mock instance can be provided instead of the real one.
  /// Firs the method counts the amount of questions in a given category of the question, then it adds the number counted to the word 'question' to get the ID of the question
  /// then it checks if this ID already exists, if yes, it adds 1 to the number and tries again, if not, it adds the question to firebase
  Future<void> addQuestion(FirebaseFirestore? firestore) async {
    if (firestore == null) {
      firestore = FirebaseFirestore.instance;
    }

    int questionCount = 0;
    await firestore.collection('categories')
        .doc(owner)
        .collection(category)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        questionCount++;
      });
    });

    String newQuestionID = "";
    newQuestionID = 'question' + questionCount.toString();

    // check if the newQuestionID already exists in the category, if so add 1 to the questionCount, then run newQuestionID = 'question' + questionCount.toString(); again, until a new id is found
    bool idExists = true;
    while (idExists) {
      idExists = false;
      await firestore.collection('categories')
          .doc(owner)
          .collection(category)
          .doc(newQuestionID)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          idExists = true;
          questionCount++;
          newQuestionID = 'question' + questionCount.toString();
        }
      });
    }

    await firestore.collection('categories')
        .doc(owner)
        .collection(category)
        .doc(newQuestionID)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        print('Question id already exists');
      } else {
        firestore?.collection('categories')
            .doc(owner)
            .collection(category)
            .doc(newQuestionID)
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
