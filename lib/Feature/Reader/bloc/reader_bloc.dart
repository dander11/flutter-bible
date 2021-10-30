import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:darq/darq.dart';

import '../../../Foundation/Models/Book.dart';
import '../../../Foundation/Models/Chapter.dart';
import '../../../Foundation/Models/ChapterReference.dart';
import '../../../Foundation/Provider/IBibleProvider.dart';
import 'package:bloc/bloc.dart';

import 'reader_event.dart';
import 'reader_state.dart';

class ReaderBloc extends HydratedBloc<ReaderEvent, ReaderState> {
  final IBibleProvider importer;
  List<Book> _books;
  Chapter _currentChapter;
  Chapter _nextChapter;
  Chapter _prevChapter;

  ReaderBloc(this.importer) : super(ReaderInitial()) {
    _getBooks();
    on<ReaderGoToChapter>(_goToChapter);
  }

  FutureOr<void> _goToChapter(
      ReaderGoToChapter event, Emitter<ReaderState> emit) async {
    if (_books == null) {
      await _getBooks();
    }
    if (event.reference.chapter != _nextChapter &&
        event.reference.chapter != _prevChapter &&
        event.reference.chapter != _currentChapter) {
      emit(ReaderLoading());
    }
    _currentChapter = await _getChapter(event.reference);
    var futures = await Future.wait([
      _getNextChapter(_currentChapter),
      _getPreviousChapter(_currentChapter),
    ]);
    _nextChapter = futures.first;
    _prevChapter = futures.last;

    emit(ReaderLoaded(
        ChapterReference(chapter: _currentChapter, verseNumber: 1),
        _nextChapter,
        _prevChapter));
  }

  Future<Null> _getBooks() async {
    await importer.init();
    _books = await importer.getAllBooks();
  }

  Future<Chapter> _getChapter(ChapterReference currentChapter) async {
    var chapter = await importer.getChapter(
        currentChapter.chapter.book.name, currentChapter.chapter.number);
    currentChapter.chapter.elements = chapter.elements;

    return chapter;
  }

  Future<Chapter> _getPreviousChapter(Chapter currentChapter) async {
    Chapter prevChapter;
    if (currentChapter.number != 1) {
      prevChapter = await importer.getChapter(
          currentChapter.book.name, currentChapter.number - 1);
    } else {
      var prevBook = _books.indexOf(currentChapter.book) != 0
          ? _books[_books.indexOf(currentChapter.book) - 1]
          : _books.last;
      prevChapter =
          await importer.getChapter(prevBook.name, prevBook.chapters.length);
    }
    return prevChapter;
  }

  Future<Chapter> _getNextChapter(Chapter currentChapter) async {
    Chapter nextChapter;
    if (currentChapter.number != currentChapter.book.chapters.length) {
      nextChapter = await importer.getChapter(
          currentChapter.book.name, currentChapter.number + 1);
    } else {
      var nextBook = _books.indexOf(currentChapter.book) != (_books.length - 1)
          ? _books[_books.indexOf(currentChapter.book) + 1]
          : _books.first;
      nextChapter = await importer.getChapter(nextBook.name, 1);
    }
    return nextChapter;
  }

  @override
  ReaderState fromJson(Map<String, dynamic> json) {
    try {
      if (json.isNotEmpty && json.containsKey('currentChapter')) {
        _getBooks().then((value) {
          var reference = ChapterReference.fromJson(json['currentChapter']);
          var chapter = _books
              .firstWhere(
                  (element) => element.name == reference.chapter.book.name)
              .chapters
              .firstWhere(
                  (chapter) => chapter.number == reference.chapter.number);
          reference = ChapterReference(
              chapter: chapter, verseNumber: reference.verseNumber);
        });
      } else {
        _getBooks().then((value) => this.add(ReaderGoToChapter(ChapterReference(
            chapter: _books.first.chapters.first, verseNumber: 1))));
      }
    } catch (e) {
      _getBooks().then((value) => this.add(ReaderGoToChapter(ChapterReference(
          chapter: _books.first.chapters.first, verseNumber: 1))));
    }

    return ReaderLoading();
  }

  @override
  Map<String, dynamic> toJson(ReaderState state) {
    var json = <String, dynamic>{};
    if (state is ReaderLoaded) {
      json.putIfAbsent(
          'currentChapter', () => state.currentChapterReference.toJson());
    }
    return json;
  }
}
