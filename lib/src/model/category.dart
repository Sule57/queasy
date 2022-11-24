import 'dart:ui';

import 'package:queasy/src/model/question.dart';

enum Categories {
  science,
  history,
  art,
  geography,
  sports,
  entertainment,
}

class Category {
  List<Question> questions;
  Color color;

  Category(this.questions, this.color);
}
