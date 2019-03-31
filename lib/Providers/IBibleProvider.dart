import 'package:bible_bloc/Models/Book.dart';
import 'package:bible_bloc/Models/Chapter.dart';

abstract class IBibleProvider {
  Future<List<Book>> getAllBooks();

  Future<Chapter> getChapter(String bookName, int chapterNumber);

  Future init();
}
