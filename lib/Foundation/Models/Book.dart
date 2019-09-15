import 'Chapter.dart';

class Book {
  int id;
  final String name;
  List<Chapter> chapters;

  Book({this.name, this.chapters});
}
