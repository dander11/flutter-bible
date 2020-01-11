import 'Book.dart';
import 'ChapterElements/IChapterElement.dart';

class Chapter {
  int id;
  List<IChapterElement> elements;
  Book book;
  int number;
  String referenceName;

  Chapter({this.number, this.elements, this.book, this.referenceName}) {
    if (this.elements == null) {
      elements = List<IChapterElement>();
    }
  }

  @override
  String toString() {
    return "${book.name} $number";
  }

  @override
  int get hashCode {
    return ("${book.name} + $number").hashCode;
  }

  operator ==(Object other) => hashCode == other.hashCode;
}
