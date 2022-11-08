import 'package:queasy/model/question.dart';
import 'package:queasy/model/quiz.dart';

class QuizViewController {
  late Quiz quiz;
  int currentQuestionIndex = 0;
  int totalQuestions = 10;
  late List<Question> questions;
  late Question question;
  String category = 'Science';
  int totalPoints = 0;

  QuizViewController() {
    initQuiz();
  }

  void initQuiz() {
    quiz = Quiz(
      id: 1,
      noOfQuestions: 5,
      category: 'Science',
    );
    questions = quiz.getQuestions();
    question = questions[currentQuestionIndex];
  }

  String getQuestionText() {
    return question.getText();
  }

  String getAnswerText(int index) {
    return question.getAnswer(index).getText();
  }
}
