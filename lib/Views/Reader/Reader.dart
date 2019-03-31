import 'dart:collection';
import 'package:bible_bloc/InheritedBlocs.dart';
import 'package:bible_bloc/Models/Book.dart';
import 'package:bible_bloc/Models/Chapter.dart';
import 'package:bible_bloc/Views/ChapterViewer/DismissableChapterViewer.dart';
import 'package:bible_bloc/Views/LoadingColumn.dart';
import 'package:flutter/material.dart';

class Reader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: InheritedBlocs.of(context).bibleBloc.chapter,
      //initialData: Chapter(1, []),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          //saveCurrentBookAndChapter();
          return StreamBuilder<bool>(
            stream: InheritedBlocs.of(context).settingsBloc.showVerseNumbers,
            initialData: false,
            builder: (BuildContext context, AsyncSnapshot<bool> setting) {
              if (setting.hasData) {
                return DismissableChapterViewer(
                  addBackgrounds: true,
                  book: snapshot.data.book,
                  chapter: snapshot.data,
                  swipeAction: (direction) =>
                      swipeVersesAway(direction, context),
                  showVerseNumbers: setting.data,
                );
              } else {
                return DismissableChapterViewer(
                  addBackgrounds: true,
                  book: snapshot.data.book,
                  chapter: snapshot.data,
                  swipeAction: (direction) =>
                      swipeVersesAway(direction, context),
                  showVerseNumbers: true,
                );
              }
            },
          );
        } else {
          //readCurrentBookAndChapter();
          return new LoadingColumn();
        }
      },
    );
  }

  swipeVersesAway(DismissDirection swipeDetails, BuildContext context) async {
    Chapter currentChapter =
        await InheritedBlocs.of(context).bibleBloc.chapter.first;
    var books = await InheritedBlocs.of(context).bibleBloc.books.first;
    if (swipeDetails == DismissDirection.endToStart) {
      goToNextChapter(books, currentChapter, context);
    } else {
      goToPreviousChapter(books, currentChapter, context);
    }
    // saveCurrentBookAndChapter();
  }

  void goToPreviousChapter(UnmodifiableListView<Book> books,
      Chapter currentChapter, BuildContext context) {
    if (books.first == currentChapter.book && currentChapter.number == 1) {
      var prevBook = books.last;
      InheritedBlocs.of(context)
          .bibleBloc
          .currentChapter
          .add(prevBook.chapters.last);
    } else if (1 == currentChapter.number) {
      var prevBook = books[books.indexOf(currentChapter.book) - 1];
      InheritedBlocs.of(context)
          .bibleBloc
          .currentChapter
          .add(prevBook.chapters.last);
    } else {
      Chapter prevChapter = currentChapter.book
          .chapters[currentChapter.book.chapters.indexOf(currentChapter) - 1];
      InheritedBlocs.of(context).bibleBloc.currentChapter.add(prevChapter);
    }
  }

  void goToNextChapter(UnmodifiableListView<Book> books, Chapter currentChapter,
      BuildContext context) {
    if (books.last == currentChapter.book &&
        currentChapter.number == currentChapter.book.chapters.length) {
      var nextBook = books.first;
      InheritedBlocs.of(context)
          .bibleBloc
          .currentChapter
          .add(nextBook.chapters.first);
    } else if (currentChapter.book.chapters.length == currentChapter.number) {
      var nextBook = books[books.indexOf(currentChapter.book) + 1];
      InheritedBlocs.of(context)
          .bibleBloc
          .currentChapter
          .add(nextBook.chapters.first);
    } else {
      Chapter nextChapter = currentChapter.book
          .chapters[currentChapter.book.chapters.indexOf(currentChapter) + 1];
      InheritedBlocs.of(context).bibleBloc.currentChapter.add(nextChapter);
    }
  }
}
