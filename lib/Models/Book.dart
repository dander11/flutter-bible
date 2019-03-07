import 'Chapter.dart';


class Book {
  int id;
  final String name;
  List<Chapter> chapters;

  Book({this.name, this.chapters});

  Chapter getChapter(int chapterNumber) {
    if (chapterNumber < 0 || chapterNumber > chapters.length) {
      throw new ArgumentError("This chapter doesn't exist in this book");
    }

    return chapters[chapterNumber - 1];
  }

}
