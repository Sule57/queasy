import 'package:queasy/model/category.dart';

import 'answer.dart';

class Question {
  final String text;
  final List<Answer> answers;
  // Categories category;

  Question(this.text, this.answers);
}
