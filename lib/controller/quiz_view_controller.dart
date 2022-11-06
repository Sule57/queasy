import 'package:queasy/model/question.dart';
import 'package:queasy/model/quiz.dart';

class QuizzViewController {
  Quiz quiz = Quiz(
    id: 1,
    noOfQuestions: 5,
    category: 'Science',
  );
  int currentQuestionIndex = 0;
  late List<Question> questions;
  late Question question;

  QuizzViewController() {
    questions = quiz.getQuestions();
    if (questions == null) {
      print('questions is null');
    }
    question = questions[currentQuestionIndex];
  }

  String getQuestionText() {
    return question.getText();
    // return "";
  }

  String getAnswerText(int index) {
    return question.getAnswer(index).getText();
    // return "";
  }
}
