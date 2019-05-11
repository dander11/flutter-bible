import 'dart:async';

import 'package:bible_bloc/Models/Book.dart';
import 'package:bible_bloc/Models/Chapter.dart';
import 'package:bible_bloc/Models/ChapterElements/IChapterElement.dart';
import 'package:bible_bloc/Models/ChapterElements/Verse.dart';
import 'package:bible_bloc/Models/ChapterReference.dart';

import 'package:bible_bloc/Models/SearchQuery.dart';

import 'package:bible_bloc/Providers/IBibleProvider.dart';
import 'package:bible_bloc/Providers/ISearchProvider.dart';
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

  Sink<ChapterReference> get currentChapterReference =>
      _currentChapterController.sink;
  final _currentChapterController = StreamController<ChapterReference>();

  Stream<ChapterReference> get chapterReference => _currentChapter.stream;
  final _currentChapter = BehaviorSubject<ChapterReference>();

  Sink<ChapterReference> get currentPopupChapterReference =>
      _currentPopupChapterController.sink;
  final _currentPopupChapterController = StreamController<ChapterReference>();

  Stream<ChapterReference> get popupChapterReference => _popupChapter.stream;
  final _popupChapter = BehaviorSubject<ChapterReference>();

  Observable<ChapterReference> get chapterHistory => _chapterHistory.stream;
  final _chapterHistory = BehaviorSubject<ChapterReference>();

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

  BibleBloc(IBibleProvider bibleProvider, ISearchProvider searchProvider) {
    _importer = bibleProvider;
    _getBooks().then((n) => _initCurrentBook());

    _searchProvider = searchProvider;
    _searchProvider.init();

    _currentChapterController.stream.listen((currentChapter) async {
      _goToChapter(currentChapter);
    });

    /* _chapterHistory.stream.listen((_) {
      _chapterHistory.toList().then((history) {
        _saveHistoryToFile(history);
      });
    }); */

    _currentPopupChapterController.stream.listen((popupReference) async {
      _updatePopupChapter(popupReference);
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
              .expand((b) => [b.name])
              .toList()
          : this._books.expand((b) => [b.name]).toList();
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
              .expand((b) => [b.name])
              .toList()
          : this._books.expand((b) => [b.name]).toList();
      _searchProvider
          .getSearchResults(search.queryText, booksToSearch)
          .then((results) {
        _searchResultsSubject.add(UnmodifiableListView(results));
      });
    }
  }

  Future _goToChapter(ChapterReference currentChapter) async {
    var chapter = await _importer.getChapter(
        currentChapter.chapter.book.name, currentChapter.chapter.number);
    _chapterElementsSubject.add(UnmodifiableListView(chapter.elements));
    currentChapter.chapter.elements = chapter.elements;
    await _updatePreviousChapter(currentChapter.chapter);

    await _updateNextChapter(currentChapter.chapter);

    _currentChapter.add(currentChapter);

    _chapterHistory.add(currentChapter);
    chapterHistory.toList().then((history) {
      print(history.length);
    });
    _saveCurrentBookAndChapter();
  }

  Future _updateNextChapter(Chapter currentChapter) async {
    var nextChapter = await _getNextChapter(currentChapter);
    _nextChapter.add(nextChapter);
  }

  Future<Chapter> _getNextChapter(Chapter currentChapter) async {
    Chapter nextChapter;
    if (currentChapter.number != currentChapter.book.chapters.length) {
      nextChapter = await _importer.getChapter(
          currentChapter.book.name, currentChapter.number + 1);
    } else {
      var nextBook = _books.indexOf(currentChapter.book) != (_books.length - 1)
          ? _books[_books.indexOf(currentChapter.book) + 1]
          : _books.first;
      nextChapter = await _importer.getChapter(nextBook.name, 1);
    }
    return nextChapter;
  }

  Future _updatePreviousChapter(Chapter currentChapter) async {
    Chapter prevChapter = await _getPreviousChapter(currentChapter);
    _previousChapter.add(prevChapter);
  }

  Future<Chapter> _getPreviousChapter(Chapter currentChapter) async {
    Chapter prevChapter;
    if (currentChapter.number != 1) {
      prevChapter = await _importer.getChapter(
          currentChapter.book.name, currentChapter.number - 1);
    } else {
      var prevBook = _books.indexOf(currentChapter.book) != 0
          ? _books[_books.indexOf(currentChapter.book) - 1]
          : _books.last;
      prevChapter =
          await _importer.getChapter(prevBook.name, prevBook.chapters.length);
    }
    return prevChapter;
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
    _currentPopupChapterController.close();
    _chapterHistory.close();
  }

  void _initCurrentBook() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var currentChapterString = sp.getString(membershipKey);
    if (currentChapterString != null && currentChapterString.contains("_")) {
      var bookName = currentChapterString.split("_")[0];
      var chapterNumber = int.parse(currentChapterString.split("_")[1]);
      // var verseNumber = int.tryParse(currentChapterString.split("_")[2]);
      var chapterReference = ChapterReference(
        chapter: await _importer.getChapter(bookName, chapterNumber),
        //verseNumber: verseNumber,
      );
      currentChapterReference.add(chapterReference);
    } else {
      var chapterReference = ChapterReference(
          chapter: await _importer.getChapter(_books.first.name, 1));
      currentChapterReference.add(chapterReference);
    }
  }

  void _saveCurrentBookAndChapter() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var currentChapter = _currentChapter.value;
    sp.setString(membershipKey,
        "${currentChapter.chapter.book.name}_${currentChapter.chapter.number}_${currentChapter.verseNumber}");
  }

  Future _updatePopupChapter(ChapterReference popupReference) async {
    if (popupReference != null) {
      var chapter = await _importer.getChapter(
          popupReference.chapter.book.name, popupReference.chapter.number);
      _chapterElementsSubject.add(UnmodifiableListView(chapter.elements));
      popupReference.chapter.elements = chapter.elements;
    }

    _popupChapter.add(popupReference);
  }

  void _saveHistoryToFile(List<ChapterReference> history) {}

  Future goToNextChapter(Chapter currentChapter) async {
    var nextChapter = await _getNextChapter(currentChapter);
    _goToChapter(ChapterReference(chapter: nextChapter));
  }

  Future goToPreviousChapter(Chapter currentChapter) async {
    var previousChapter = await _getPreviousChapter(currentChapter);
    _goToChapter(ChapterReference(chapter: previousChapter));
  }
}
