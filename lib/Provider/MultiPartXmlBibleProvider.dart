import 'package:bible_bloc/Models/Book.dart';
import 'package:bible_bloc/Models/Chapter.dart';
import 'package:bible_bloc/Models/Verse.dart';
import 'package:bible_bloc/Provider/IBibleProvider.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:xml/xml.dart' as xml;

class MultiPartXmlBibleProvider extends IBibleProvider {
  xml.XmlDocument xmlDocument;

  MultiPartXmlBibleProvider() {
    GlobalConfiguration cfg = new GlobalConfiguration();
    rootBundle
        .loadString(cfg.getString("multipartXmlBiblePath") + 'books.xml')
        .then((fileData) {
      xmlDocument = xml.parse(fileData);
    });
  }

  @override
  Future<List<Book>> getAllBooks() {
    // TODO: implement getAllBooks
    return null;
  }

  @override
  Book getBook(String name) {
    // TODO: implement getBook
    return null;
  }

  @override
  Chapter getChapter(String bookName, int chapterNumber) {
    // TODO: implement getChapter
    return null;
  }

  @override
  Future<Chapter> getChapterById(int chapterId) {
    // TODO: implement getChapterById
    return null;
  }

  @override
  List<Verse> getSearchResults(String searchTerm, List<Book> booksToSearch) {
    // TODO: implement getSearchResults
    return null;
  }

  @override
  Future init() {
    // TODO: implement init
    return null;
  }
}
