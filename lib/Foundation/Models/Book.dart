import 'Chapter.dart';

class Book {
  int id;
  final String name;
  List<Chapter> chapters;
  final int number;

  Book({this.name, this.chapters, this.number});
}
