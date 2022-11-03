import 'package:queasy/model/question.dart';

class Quiz {
  int id, noOfQuestions;
  String creatorUsername;
  late List<Question> questions;
  String category;

  Quiz({
    required this.id,
    required this.creatorUsername,
    required this.noOfQuestions,
    required this.category,
  });

  //TODO methods for quiz data
  initialize() {
    questions = [];

  }
}
