import '../Models/Book.dart';
import '../Models/Chapter.dart';
import '../Models/ChapterElements/Verse.dart';
import 'ISearchProvider.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:xml/xml.dart' as xml;
import 'package:darq/darq.dart';

class XmlBibleProvider extends ISearchProvider {
  xml.XmlDocument xmlDocument;
  GlobalConfiguration _cfg;

  List<Book> _searchableBooks;

  XmlBibleProvider() {
    _cfg = GlobalConfiguration();
  }
  Future init() async {
    var path = _cfg.getString("xmlBiblePath");
    return await loadDocument(path);
  }

  Future loadDocument(String path) async {
    var fileData = await rootBundle.loadString(path);
    xmlDocument = xml.parse(fileData);
    _searchableBooks = await getAllBooks();
  }

  Future<List<Book>> getAllBooks() async {
    var xmlBooks = xmlDocument.findAllElements("b");
    var books = List<Book>();
    for (var item in xmlBooks) {
      var book = _convertBookFromXml(item);
      books.add(book);
    }
    return books;
  }

  Book _convertBookFromXml(xml.XmlElement item) {
    var book = Book(
      name: item.getAttribute("n"),
    );
    book.chapters = _getChapters(item, book);
    return book;
  }

  Book _getBook(String name) {
    var xmlBooks = xmlDocument.findAllElements("b");
    var xmlBook = xmlBooks.firstWhere((n) => n.getAttribute("n") == name);
    var book = _convertBookFromXml(xmlBook);
    return book;
  }

  Future<Chapter> getChapter(String bookName, int chapterNumber) async {
    return this._getBook(bookName).chapters[chapterNumber - 1];
  }

  List<Chapter> _getChapters(xml.XmlElement xmlBook, Book book) {
    var xmlChapters = xmlBook.findAllElements("c");
    List<Chapter> chapters = List<Chapter>();
    for (var item in xmlChapters) {
      var chapter = Chapter(
        number: int.parse(item.getAttribute("n")),
        book: book,
      );

      chapter.elements = this._getVerses(item, chapter);

      chapters.add(chapter);
    }

    return chapters;
  }

  List<Verse> _getVerses(xml.XmlElement xmlChapter, Chapter chapter) {
    var xmlVerses = xmlChapter.findAllElements("v");
    List<Verse> verses = List<Verse>();
    for (var item in xmlVerses) {
      var verse = Verse(
        number: int.parse(item.getAttribute("n")),
        text: item.text,
        chapter: chapter,
      );
      verses.add(verse);
    }
    return verses;
  }

  Future<List<Verse>> getSearchResults(
      String searchTerm, List<String> booksToSearch) async {
    var books = booksToSearch.isNotEmpty
        ? this._searchableBooks.where((b) => booksToSearch
            .any((book) => book.toLowerCase() == b.name.toLowerCase()))
        : this._searchableBooks;

    var chapters = books.expand((book) => book.chapters);
    var verses = <Verse>[];
    verses = chapters.expand((c) => c.elements.whereType<Verse>().toList()).toList();
    verses = verses.where((verse) =>
        _contains(searchTerm.toLowerCase(), verse.text.toLowerCase())).toList();
    if (verses.contains(" ") && !searchTerm.contains(" ")) {
      verses = verses
          .where((verse) => verse.text
              .toLowerCase()
              .replaceAll(".", "")
              .split(" ")
              .contains(searchTerm.toLowerCase()))
          .toList();
    } else {
      verses = verses.where((verse) =>
          verse.text.toLowerCase().contains(searchTerm.toLowerCase())).toList();
    }
    RegExp referenceExpression = new RegExp(
        r'(\b[a-zA-Z]+)(?:\s+(\d+))?(?::(\d+)(?:–\d+)?(?:,\s*\d+(?:–\d+)?)*)?',
        caseSensitive: false);
    if (referenceExpression.hasMatch(searchTerm)) {
      var bookName = referenceExpression.firstMatch(searchTerm)?.group(1);
      var chapter = referenceExpression.firstMatch(searchTerm)?.group(2);
      var verseStart = referenceExpression.firstMatch(searchTerm)?.group(3);
      if (bookName != null && bookName.isNotEmpty) {
        var verseMatches = <Verse>[];
        var possibleBookMatches = books
            .where((element) =>
                element.name.toLowerCase().contains(bookName.toLowerCase()))
            .toList();
        if (chapter != null && chapter.isNotEmpty) {
          int chapterNumber = int.tryParse(chapter) ?? 1;

          possibleBookMatches = possibleBookMatches
              .where((element) => element.chapters.length > chapterNumber)
              .toList();
          var possiblechapters = possibleBookMatches
              .select((element, index) => element.chapters
                  .firstWhere((element) => element.number == chapterNumber))
              .toList();
          if (verseStart != null && verseStart.isNotEmpty) {
            int verseNumber = int.tryParse(chapter) ?? 1;

            possiblechapters = possiblechapters
                .where((element) =>
                    element.elements.whereType<Verse>().length > verseNumber)
                .toList();
            var verses = possiblechapters
                .select((element, index) => element.elements
                    .whereType<Verse>()
                    .firstWhere((element) => element.number == verseNumber))
                .toList();
            verseMatches.addAll(verses);
          } else {
            var verses = possiblechapters
                .select((element, index) => element.elements
                    .whereType<Verse>()
                    .firstWhere((element) => element.number == 1))
                .toList();
            verseMatches.addAll(verses);
          }
        }
        verses.isNotEmpty
            ? verses.toList().insertAll(0, verseMatches.toList())
            : verses.addAll(verseMatches.toList());
      }
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
