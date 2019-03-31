import 'dart:async';

import 'package:bible_bloc/Models/Book.dart';
import 'package:bible_bloc/Models/Chapter.dart';
import 'package:bible_bloc/Models/ChapterElements/IChapterElement.dart';
import 'package:bible_bloc/Models/ChapterElements/Verse.dart';

import 'package:bible_bloc/Models/SearchQuery.dart';

import 'package:bible_bloc/Provider/IBibleProvider.dart';
import 'package:bible_bloc/Provider/MultiPartXmlBibleProvider.dart';
import 'package:bible_bloc/Provider/XmlBibleProvider.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:collection';

class BibleBloc {
  IBibleProvider _importer;
  IBibleProvider _searchProvider;
  List<Book> _books;

  Stream<UnmodifiableListView<Book>> get books => _booksSubject.stream;
  final _booksSubject = BehaviorSubject<UnmodifiableListView<Book>>();

  Stream<UnmodifiableListView<IChapterElement>> get chapterElements =>
      _chapterElementsSubject.stream;
  final _chapterElementsSubject =
      BehaviorSubject<UnmodifiableListView<IChapterElement>>();

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

  BibleBloc() {
    _importer = MultiPartXmlBibleProvider();
    _getBooks();
    _searchProvider = XmlBibleProvider();
    _searchProvider.init();
/* 
    _importer = SqlLiteBibleProvider();
    _getBooks(); */

    _currentChapterController.stream.listen((currentChapter) async {
      //var verses = currentChapter.elements.where((e) => e is Verse);
      var chapter = await _importer.getChapter(
          currentChapter.book.name, currentChapter.number);
      _chapterElementsSubject.add(UnmodifiableListView(chapter.elements));
      currentChapter.elements = chapter.elements;
      _currentChapter.add(currentChapter);
    });

    _searchTermController.stream.listen((search) {
      if (search.queryText.length > 2) {
        var booksToSearch = search.book.isNotEmpty
            ? this
                ._books
                .where((book) =>
                    book.name.toLowerCase() == search.book.toLowerCase())
                .toList()
            : this._books;
        _searchProvider
            .getSearchResults(search.queryText, booksToSearch)
            .then((results) {
          _searchResultsSubject.add(UnmodifiableListView(results));
        });
      }
    });

    _suggestionSearchTermController.stream.listen((search) {
      if (search.queryText.length > 2) {
        var booksToSearch = search.book.isNotEmpty
            ? this
                ._books
                .where((book) =>
                    book.name.toLowerCase() == search.book.toLowerCase())
                .toList()
            : this._books;
        _searchProvider
            .getSearchResults(search.queryText, booksToSearch)
            .then((results) {
          _suggestionSearchResultsSubject.add(UnmodifiableListView(results));
        });
      }
    });
  }

  Future<Null> _getBooks() async {
    await _importer.init();
    _books = await _importer.getAllBooks();
    _booksSubject.add(UnmodifiableListView(_books));
  }

  dispose() {
    _currentChapterController.close();
    _searchTermController.close();
    _suggestionSearchTermController.close();
  }
}
