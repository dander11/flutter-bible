import 'package:bible_bloc/InheritedBlocs.dart';
import 'package:bible_bloc/Models/Book.dart';
import 'package:bible_bloc/Models/Chapter.dart';
import 'package:bible_bloc/Models/ChapterReference.dart';
import 'package:bible_bloc/Views/ChapterViewer/VerseText.dart';
import 'package:bible_bloc/Views/LoadingColumn.dart';
import 'package:flutter/material.dart';

class DismissableChapterViewer extends StatelessWidget {
  final Chapter chapter;
  final Chapter previousChapter;
  final Chapter nextChapter;
  final Book book;
  final int verseNumber;
  final bool shouldHaveBackgrounds;
  final bool showVerseNumbers;
  final Function scrollToVerseMethod;

  DismissableChapterViewer({
    this.chapter,
    this.book,
    this.shouldHaveBackgrounds,
    this.showVerseNumbers,
    this.verseNumber,
    this.scrollToVerseMethod,
    this.previousChapter,
    this.nextChapter,
  });

  Widget build(BuildContext context) {
    return new Dismissible(
      secondaryBackground: this.shouldHaveBackgrounds
          ? VerseText(
              book: book,
              chapter: nextChapter,
              verseNumber: 1,
              scrollToVerseMethod: scrollToVerseMethod,
            )
          : LoadingColumn(),
      background: this.shouldHaveBackgrounds
          ? VerseText(
              book: book,
              chapter: previousChapter,
              verseNumber: 1,
              scrollToVerseMethod: scrollToVerseMethod,
            )
          : LoadingColumn(),
      resizeDuration: null,
      onDismissed: (DismissDirection swipeDetails) async {
        if (swipeDetails == DismissDirection.endToStart) {
          InheritedBlocs.of(context).bibleBloc.goToNextChapter(this.chapter);
        } else {
          InheritedBlocs.of(context)
              .bibleBloc
              .goToPreviousChapter(this.chapter);
          print(this.chapter);
        }
      },
      child: new VerseText(
        book: book,
        chapter: chapter,
        verseNumber: verseNumber,
        scrollToVerseMethod: scrollToVerseMethod,
      ),
      key: new ValueKey(chapter.number),
    );
  }
}
