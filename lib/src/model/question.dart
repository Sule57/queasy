import 'answer.dart';

class Question {
  String text = "";
  List<Answer> answers = [];
  // String category;

  Question({
    required this.text,
    required this.answers,
    // required this.category,
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
}
