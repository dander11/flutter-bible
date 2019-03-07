import 'package:bible_bloc/Models/Book.dart';
import 'package:bible_bloc/Models/IChapterElement.dart';

class Chapter {
  int id;
  List<IChapterElement> elements;
  Book book;
  int number;

  Chapter({this.number, this.elements, this.book});
}
