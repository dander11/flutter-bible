import 'dart:async';

import 'package:bible_bloc/Models/Book.dart';
import 'package:bible_bloc/Models/Chapter.dart';
import 'package:bible_bloc/Models/ChapterElements/IChapterElement.dart';
import 'package:bible_bloc/Models/ChapterElements/Verse.dart';

import 'package:bible_bloc/Models/SearchQuery.dart';

import 'package:bible_bloc/Providers/IBibleProvider.dart';
import 'package:bible_bloc/Providers/ISearchProvider.dart';
import 'package:bible_bloc/Providers/MultiPartXmlBibleProvider.dart';
import 'package:bible_bloc/Providers/XmlBibleProvider.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';

class BibleBloc {
  IBibleProvider _importer;
  ISearchProvider _searchProvider;
  List<Book> _books;

  final String membershipKey = 'david.anderson.bibleapp';

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

  Stream<Chapter> get nextChapter => _nextChapter.stream;
  final _nextChapter = BehaviorSubject<Chapter>();

  Stream<Chapter> get previousChapter => _previousChapter.stream;
  final _previousChapter = BehaviorSubject<Chapter>();

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

    _initCurrentBook();

    _currentChapterController.stream.listen((currentChapter) async {
      await _updateChapters(currentChapter);
    });

    _searchTermController.stream.listen((search) {
      _updateSearchResults(search);
    });

    _suggestionSearchTermController.stream.listen((search) {
      _updateSearchSuggestions(search);
    });
  }

  void _updateSearchSuggestions(SearchQuery search) {
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
  }

  void _updateSearchResults(SearchQuery search) {
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
  }

  Future _updateChapters(Chapter currentChapter) async {
    var chapter = await _importer.getChapter(
        currentChapter.book.name, currentChapter.number);
    _chapterElementsSubject.add(UnmodifiableListView(chapter.elements));
    currentChapter.elements = chapter.elements;
    _currentChapter.add(currentChapter);

    await _updatePreviousChapter(currentChapter);

    await _updateNextChapter(currentChapter);
    _saveCurrentBookAndChapter();
  }

  Future _updateNextChapter(Chapter currentChapter) async {
    if (currentChapter.number != currentChapter.book.chapters.length - 1) {
      var prevChapter = await _importer.getChapter(
          currentChapter.book.name, currentChapter.number + 1);
      _previousChapter.add(prevChapter);
    } else {
      var nextBook = _books.indexOf(currentChapter.book) != (_books.length - 1)
          ? _books[_books.indexOf(currentChapter.book) + 1]
          : _books.first;
      var prevChapter = await _importer.getChapter(nextBook.name, 1);
      _previousChapter.add(prevChapter);
    }
  }

  Future _updatePreviousChapter(Chapter currentChapter) async {
    if (currentChapter.number != 1) {
      var prevChapter = await _importer.getChapter(
          currentChapter.book.name, currentChapter.number - 1);
      _previousChapter.add(prevChapter);
    } else {
      var prevBook = _books.indexOf(currentChapter.book) != 0
          ? _books[_books.indexOf(currentChapter.book) - 1]
          : _books.last;
      var prevChapter =
          await _importer.getChapter(prevBook.name, prevBook.chapters.length);
      _previousChapter.add(prevChapter);
    }
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
    _previousChapter.close();
    _nextChapter.close();
  }

  void _initCurrentBook() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var currentChapterString = sp.getString(membershipKey);
    if (currentChapterString.contains("_")) {
      var bookName = currentChapterString.split("_")[0];
      var chapterNumber = int.parse(currentChapterString.split("_")[0]);
      currentChapter.add(await _importer.getChapter(bookName, chapterNumber));
    } else {
      currentChapter.add(await _importer.getChapter(_books.first.name, 1));
    }
  }

  void _saveCurrentBookAndChapter() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var currentChapter = _currentChapter.value;
    sp.setString(
        membershipKey, "${currentChapter.book.name}_${currentChapter.number}");
  }
}
