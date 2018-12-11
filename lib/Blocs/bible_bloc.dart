import 'dart:async';

import 'package:bible_bloc/Models/Book.dart';
import 'package:bible_bloc/Models/Chapter.dart';
import 'package:bible_bloc/Models/SearchQuery.dart';
import 'package:bible_bloc/Models/Verse.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bible_bloc/Provider/BibleProvider.dart';
import 'package:xml/xml.dart' as xml;
import 'dart:collection';

class BibleBloc {
  BibleProvider _importer;
  List<Book> _books;

  Stream<UnmodifiableListView<Book>> get books => _booksSubject.stream;
  final _booksSubject = BehaviorSubject<UnmodifiableListView<Book>>();

  Stream<UnmodifiableListView<Verse>> get verses => _verseSubject.stream;
  final _verseSubject = BehaviorSubject<UnmodifiableListView<Verse>>();

  Sink<Chapter> get currentChapter => _currentChapterController.sink;
  final _currentChapterController = StreamController<Chapter>();

  Stream<Chapter> get chapter => _currentChapter.stream;
  final _currentChapter = BehaviorSubject<Chapter>();

  Sink<SearchQuery> get searchTerm => _searchTermController.sink;
  final _searchTermController = StreamController<SearchQuery>();

  Stream<UnmodifiableListView<Verse>> get searchResults =>
      _searchResultsSubject.stream;
  final _searchResultsSubject = BehaviorSubject<UnmodifiableListView<Verse>>();

  Sink<SearchQuery> get suggestionSearchTerm =>
      _suggestionSearchTermController.sink;
  final _suggestionSearchTermController = StreamController<SearchQuery>();

  Stream<UnmodifiableListView<Verse>> get suggestionSearchearchResults =>
      _suggestionSearchResultsSubject.stream;
  final _suggestionSearchResultsSubject =
      BehaviorSubject<UnmodifiableListView<Verse>>();

  BibleBloc(String bibleFilePath) {
    rootBundle.loadString(bibleFilePath).then((fileData) {
      xml.XmlDocument xmlDocument = xml.parse(fileData);
      _importer = BibleProvider(xmlDocument: xmlDocument);
      _getBooks();
    });

    _currentChapterController.stream.listen((currentChapter) {
      _verseSubject.add(UnmodifiableListView(currentChapter.verses));
      _currentChapter.add(currentChapter);
    });

    _searchTermController.stream.listen((search) {
      var booksToSearch = search.book.isNotEmpty
          ? this
              ._books
              .where((book) =>
                  book.name.toLowerCase() == search.book.toLowerCase())
              .toList()
          : this._books;
      List<Verse> results =
          BibleProvider.getSearchResults(search.queryText, booksToSearch);
      _searchResultsSubject.add(UnmodifiableListView(results));
    });

    _suggestionSearchTermController.stream.listen((search) {
      var booksToSearch = search.book.isNotEmpty
          ? this
              ._books
              .where((book) =>
                  book.name.toLowerCase() == search.book.toLowerCase())
              .toList()
          : this._books;
      List<Verse> results =
          BibleProvider.getSearchResults(search.queryText, booksToSearch);
      _suggestionSearchResultsSubject.add(UnmodifiableListView(results));
    });
  }

  Future<Null> _getBooks() async {
    _books = await _importer.getAllBooks();
    _booksSubject.add(UnmodifiableListView(_books));
  }

  dispose() {
    _currentChapterController.close();
    _searchTermController.close();
    _suggestionSearchTermController.close();
  }
}
