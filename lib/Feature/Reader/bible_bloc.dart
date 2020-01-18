import 'dart:async';
import 'dart:convert';
import 'package:bible_bloc/Foundation/Models/Book.dart';
import 'package:bible_bloc/Foundation/Models/Chapter.dart';
import 'package:bible_bloc/Foundation/Models/ChapterElements/CrossReferenceElement.dart';
import 'package:bible_bloc/Foundation/Models/ChapterReference.dart';
import 'package:bible_bloc/Foundation/Models/CrossReference.dart';
import 'package:bible_bloc/Foundation/Models/CrossReference.dart';
import 'package:bible_bloc/Foundation/Models/CrossReferenceElements/ICrossReferenceElement.dart';
import 'package:bible_bloc/Foundation/Models/CrossReferenceElements/PlainTextReferenceElement.dart';
import 'package:bible_bloc/Foundation/Models/CrossReferenceElements/VerseReferenceElement.dart';
import 'package:bible_bloc/Foundation/Provider/IBibleProvider.dart';
import 'package:bible_bloc/Foundation/Provider/IReferenceProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';

class BibleBloc {
  IBibleProvider _importer;
  IReferenceProvider _referenceProvider;
  List<Book> _books;

  final String membershipKey = 'david.anderson.bibleapp';

  Stream<UnmodifiableListView<Book>> get books => _booksSubject.stream;
  final _booksSubject = BehaviorSubject<UnmodifiableListView<Book>>();

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

  BehaviorSubject<List<ChapterReference>> get chapterHistory =>
      _chapterHistory.stream;
  final _chapterHistory = BehaviorSubject<List<ChapterReference>>();

  Stream<Chapter> get nextChapter => _nextChapter.stream;
  final _nextChapter = BehaviorSubject<Chapter>();

  Stream<Chapter> get previousChapter => _previousChapter.stream;
  final _previousChapter = BehaviorSubject<Chapter>();

  BehaviorSubject<CrossReference> get crossReference => _crossReference;
  final _crossReference = BehaviorSubject<CrossReference>();

  BibleBloc(
      IBibleProvider bibleProvider, IReferenceProvider referenceProvider) {
    _importer = bibleProvider;
    _referenceProvider = referenceProvider;
    _getBooks().then((n) => _initCurrentBook());
    _initHistoryList();
    _currentChapterController.stream.listen((currentChapter) async {
      _goToChapter(currentChapter);
    });

    _currentPopupChapterController.stream.listen((popupReference) async {
      _updatePopupChapter(popupReference);
    });
  }
  Future _goToChapter(ChapterReference currentChapter) async {
    var chapter = await _importer.getChapter(
        currentChapter.chapter.book.name, currentChapter.chapter.number);
    currentChapter.chapter.elements = chapter.elements;
    await _updatePreviousChapter(currentChapter.chapter);

    await _updateNextChapter(currentChapter.chapter);

    _currentChapter.add(currentChapter);

    var updatedHistory = _chapterHistory.value ?? List<ChapterReference>();
    updatedHistory.add(currentChapter);
    _chapterHistory.add(updatedHistory);
    _saveHistoryToFile();
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
    _saveHistoryToFile();
    _saveCurrentBookAndChapter();
    _currentChapterController.close();
    _previousChapter.close();
    _nextChapter.close();
    _currentPopupChapterController.close();
    _chapterHistory.close();
    _crossReference.close();
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
    if (popupReference == null) {
      _popupChapter.add(popupReference);
    } else {
      var chapter = await _importer.getChapter(
          popupReference.chapter.book.name, popupReference.chapter.number);
      _popupChapter.add(ChapterReference(
        chapter: chapter,
        verseNumber: popupReference.verseNumber,
      ));
    }
  }

  void _initHistoryList() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var historyJson = sp.getString((membershipKey + "-history"));
    if (historyJson != null) {
      var history = jsonDecode(historyJson) as List<ChapterReference>;
      _chapterHistory.add(history);
    }
  }

  Future _saveHistoryToFile() async {
    var history = _chapterHistory.value;
    SharedPreferences sp = await SharedPreferences.getInstance();
    var historyJson = jsonEncode(history.map((e) => e.toJson()).toList());
    sp.setString((membershipKey + "-history"), historyJson);
  }

  Future goToNextChapter(Chapter currentChapter) async {
    var nextChapter = await _getNextChapter(currentChapter);
    _goToChapter(ChapterReference(chapter: nextChapter));
  }

  Future goToPreviousChapter(Chapter currentChapter) async {
    var previousChapter = await _getPreviousChapter(currentChapter);
    _goToChapter(ChapterReference(chapter: previousChapter));
  }

  clearHistory() {
    _chapterHistory.add(List<ChapterReference>());
  }

  void addChapterReferenceFromId(String referenceId) async {
    var bookNumber = referenceId.substring(1, 3);
    var chapterNumber = referenceId.substring(3, 6);
    var verseNumber = referenceId.substring(6, 9);
    var referenceNumber = referenceId.split(".")[1];
    var chapter = _books
        .firstWhere((book) => book.number == int.parse(bookNumber))
        .chapters
        .firstWhere((chapter) => chapter.number == int.parse(chapterNumber));
    //var chapter = _importer.getChapterByBookNumber(int.parse(bookNumber), int.parse(chapterNumber));
    var fileData =
        await rootBundle.loadString(chapter.referenceName, cache: true);
    var fileLines = fileData.split("\r\n");
    fileLines.forEach((f) => f.trim());
    var referenceLine = fileLines.firstWhere((line) =>
        line.startsWith("i") && line.split(" ")[1].contains(referenceId));
    var nextReferenceStartLine = fileLines.firstWhere(
      (line) =>
          fileLines.indexOf(line) > fileLines.indexOf(referenceLine) &&
          line.startsWith("c"),
      orElse: () {
        return fileLines.last;
      },
    );
    var referenceLines = fileLines
        .getRange(fileLines.indexOf(referenceLine) - 1,
            fileLines.indexOf(nextReferenceStartLine))
        .toList();

    CrossReference reference = CrossReference(
      elements: List<ICrossReferenceElement>(),
      id: referenceId,
    );
    var userLines = "";
    var referencedId = "";
    for (var line in referenceLines) {
      if (line.startsWith("i")) {
      } else if (line.startsWith("c")) {
        var text = line.split("c ")[1];
        reference.letter = text;
      } else if (line.startsWith("m")) {
        var text = line.split("m ")[1];
        reference.elements.add(
          PlainTextReferenceElement(text: text),
        );
      } else if (line.startsWith("r")) {
        var referenceIdOnLine = line.split(" ")[1];
        referencedId = referenceIdOnLine;
        var lineText = line.split(referenceIdOnLine)[1];

        var startingVerseId = referenceIdOnLine.contains("-")
            ? referenceIdOnLine.split("-")[0]
            : referenceIdOnLine.trim();
        var endingVerseId = referenceIdOnLine.contains("-")
            ? referenceIdOnLine.split("-")[1]
            : referenceIdOnLine.trim();
        reference.elements.add(
          VerseReferenceElement(
              text: lineText,
              startingVerseId: startingVerseId,
              endingVerseId: endingVerseId),
        );
      } else if (line.startsWith("V")) {}
    }

    _crossReference.add(reference);

    /*  bookNumber = referencedId.substring(0, 2);
    chapterNumber = referencedId.substring(2, 5);
    verseNumber = referencedId.substring(5);
    var refChapter = await _importer.getChapterByBookNumber(
        int.parse(bookNumber), int.parse(chapterNumber));
    _updatePopupChapter(ChapterReference(
        chapter: refChapter, verseNumber: int.parse(verseNumber)));

    print(userLines); */
  }

  updatePopupReferenceFromCrossReference(
      VerseReferenceElement reference) async {
    var bookNumber = reference.startingVerseId.substring(0, 2);
    var chapterNumber = reference.startingVerseId.substring(2, 5);
    var verseNumber = reference.startingVerseId.substring(5);
    var refChapter = await _importer.getChapterByBookNumber(
        int.parse(bookNumber), int.parse(chapterNumber));
    _updatePopupChapter(ChapterReference(
        chapter: refChapter, verseNumber: int.parse(verseNumber)));
  }
}
