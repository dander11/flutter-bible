import 'package:bible_bloc/Models/Book.dart';
import 'package:bible_bloc/Models/Chapter.dart';
import 'package:bible_bloc/Models/ChapterElements/Verse.dart';

import 'package:bible_bloc/Providers/IBibleProvider.dart';
import 'package:bible_bloc/Providers/ISearchProvider.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:xml/xml.dart' as xml;

class XmlBibleProvider extends IBibleProvider implements ISearchProvider {
  xml.XmlDocument xmlDocument;
  GlobalConfiguration _cfg;

  List<Book> _searchableBooks;

  XmlBibleProvider() {
    _cfg = new GlobalConfiguration();
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
    List<Chapter> chapters = new List<Chapter>();
    for (var item in xmlChapters) {
      var chapter = new Chapter(
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
    List<Verse> verses = new List<Verse>();
    for (var item in xmlVerses) {
      var verse = new Verse(
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
    var books = this._searchableBooks.where((b) => booksToSearch
        .any((book) => book.toLowerCase() == b.name.toLowerCase()));
    var chapters = books.expand((book) => book.chapters);

    var verses = chapters.expand((c) => c.elements.whereType<Verse>());
    verses = verses.where((verse) =>
        _contains(searchTerm.toLowerCase(), verse.text.toLowerCase()));
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
