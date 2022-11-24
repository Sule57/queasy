import 'answer.dart';

class Question {
  final String text;
  final List<Answer> answers;
  // String category;

  Question({
    required this.text,
    required this.answers,
    // required this.category,
  });

  String getText() {
    return text;
  }

  Answer getAnswer(int index) {
    return answers[index];
  }
}
