import 'package:bible_bloc/Models/Book.dart';
import 'package:bible_bloc/Models/Chapter.dart';
import 'package:bible_bloc/Models/Verse.dart';
import 'package:xml/xml.dart' as xml;

class BibleProvider {
  final xml.XmlDocument xmlDocument;

  BibleProvider({this.xmlDocument});

  Future<List<Book>> getAllBooks() async {
    var xmlBooks = xmlDocument.findAllElements("b");
    var books = new List<Book>();
    for (var item in xmlBooks) {
      var book = _convertBookFromXml(item);
      books.add(book);
    }
    return books;
  }

  Book _convertBookFromXml(xml.XmlElement item) {
    var book = new Book(
      name: item.getAttribute("n"),
      chapters: getChapters(item),
    );
    book.chapters.forEach((c) => c.book = book);
    return book;
  }

  Book getBook(String name) {
    var xmlBooks = xmlDocument.findAllElements("b");
    var xmlBook = xmlBooks.firstWhere((n) => n.getAttribute("n") == name);
    var book = _convertBookFromXml(xmlBook);
    return book;
  }

  Chapter getChapter(String bookName, int chapterNumber) {
    return this.getBook(bookName).chapters[chapterNumber - 1];
  }

  List<Chapter> getChapters(xml.XmlElement xmlBook) {
    var xmlChapters = xmlBook.findAllElements("c");
    List<Chapter> chapters = new List<Chapter>();
    for (var item in xmlChapters) {
      var chapter =
          new Chapter(int.parse(item.getAttribute("n")), this.getVerses(item));
      chapter.verses.forEach((v) => v.chapter = chapter);
      chapters.add(chapter);
    }

    return chapters;
  }

  List<Verse> getVerses(xml.XmlElement xmlChapter) {
    var xmlVerses = xmlChapter.findAllElements("v");
    List<Verse> verses = new List<Verse>();
    for (var item in xmlVerses) {
      var verse = new Verse(
        number: int.parse(item.getAttribute("n")),
        text: item.text,
      );
      verses.add(verse);
    }
    return verses;
  }

  static List<Verse> getSearchResults(
      String searchTerm, List<Book> booksToSearch) {
    var chapters = booksToSearch.expand((book) => book.chapters);

    var verses = chapters.expand((c) => c.verses);
    verses = verses.where((verse) =>
        _contains(searchTerm.toLowerCase(), verse.text.toLowerCase()));
    if (verses.contains(" ")) {
      verses = verses
          .where((verse) => verse.text
              .toLowerCase()
              .split(" ")
              .contains(searchTerm.toLowerCase()))
          .toList();
    } else {
      verses = verses.where((verse) =>
          verse.text.toLowerCase().contains(searchTerm.toLowerCase()));
    }
    return verses.toList();
  }

  static bool _contains(String query, String verse) {
    int i = 2; // First index to check.
    int length = verse.length;
    var C = query[query.length - 1];
    var B = query[query.length - 2];
    var A = query[query.length - 3];
    while (i < length) {
      if (verse[i] == C) {
        if (verse[i - 1] == B && verse[i - 2] == A) {
          return true;
        }
        // Must be at least 3 character away.
        i += 3;
        continue;
      } else if (verse[i] == B) {
        // Must be at least 1 characters away.
        i += 1;
        continue;
      } else if (verse[i] == A) {
        // Must be at least 2 characters away.
        i += 2;
        continue;
      } else {
        // Must be at least 4 characters away.
        i += 3;
        continue;
      }
    }

    // Nothing found.
    return false;
  }
}
