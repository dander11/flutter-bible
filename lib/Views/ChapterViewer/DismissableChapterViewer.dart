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
  final bool addBackgrounds;
  final bool showVerseNumbers;
  final Function scrollToVerseMethod;

  DismissableChapterViewer({
    this.chapter,
    this.book,
    this.addBackgrounds,
    this.showVerseNumbers,
    this.verseNumber,
    this.scrollToVerseMethod,
    this.previousChapter,
    this.nextChapter,
  });

  Widget build(BuildContext context) {
    return new Dismissible(
      secondaryBackground: this.addBackgrounds
          ? VerseText(
              book: book,
              chapter: nextChapter,
              verseNumber: 1,
              scrollToVerseMethod: scrollToVerseMethod,
            )
          : LoadingColumn(),
      background: this.addBackgrounds
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
          InheritedBlocs.of(context)
              .bibleBloc
              .currentChapterReference
              .add(ChapterReference(chapter: nextChapter));
        } else {
          InheritedBlocs.of(context)
              .bibleBloc
              .currentChapterReference
              .add(ChapterReference(chapter: previousChapter));
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

class _NextChapter extends StatelessWidget {
  const _NextChapter({
    Key key,
    @required this.showVerseNumbers,
    this.scrollToVerseMethod,
  }) : super(key: key);

  final bool showVerseNumbers;
  final Function scrollToVerseMethod;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: InheritedBlocs.of(context).bibleBloc.nextChapter,
      initialData: null,
      builder: (BuildContext _, chapter) {
        if (chapter.hasData) {
          return new DismissableChapterViewer(
            chapter: chapter.data,
            book: chapter.data.book,
            addBackgrounds: false,
            showVerseNumbers: this.showVerseNumbers,
            scrollToVerseMethod: scrollToVerseMethod,
          );
        } else {
          return LoadingColumn();
        }
      },
    );
  }
}

class _PreviousChapter extends StatelessWidget {
  const _PreviousChapter({
    Key key,
    @required this.showVerseNumbers,
    this.scrollToVerseMethod,
  }) : super(key: key);

  final bool showVerseNumbers;
  final Function scrollToVerseMethod;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: InheritedBlocs.of(context).bibleBloc.previousChapter,
      initialData: null,
      builder: (BuildContext _, chapter) {
        if (chapter.hasData) {
          return new DismissableChapterViewer(
            chapter: chapter.data,
            book: chapter.data.book,
            addBackgrounds: false,
            showVerseNumbers: this.showVerseNumbers,
            scrollToVerseMethod: scrollToVerseMethod,
          );
        } else {
          return LoadingColumn();
        }
      },
    );
  }
}
