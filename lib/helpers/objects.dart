class Category {
  String label;
  String value;
  List<Platform> platforms = List();

  Category(this.label, this.value, this.platforms);
}

class Platform {
  String label;
  String value;
  List<Court> courts = List();

  Platform(this.label, this.value, this.courts);
}

class Court {
  String label;
  String value;

  Court(this.label, this.value);
}
