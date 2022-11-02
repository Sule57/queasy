import 'dart:ui';

enum Categories {
  science,
  history,
  art,
  geography,
  sports,
  entertainment,
}

class Category {
  Categories name;
  Color color;

  Category(this.name, this.color);
}
