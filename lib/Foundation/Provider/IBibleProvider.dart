
import '../Models/Book.dart';
import '../Models/Chapter.dart';

abstract class IBibleProvider {
  Future<List<Book>> getAllBooks();

  Future<Chapter> getChapter(String bookName, int chapterNumber);
  
  Future<Chapter> getChapterByBookNumber(int bookNumber, int chapterNumber);

  Future init();
}
