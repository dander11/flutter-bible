import '../../../Reader/bloc/reader_bloc.dart';
import '../../../Reader/bloc/reader_event.dart';
import '../../../Reader/bloc/reader_state.dart';
import '../../../../Foundation/Models/Book.dart';
import '../../../../Foundation/Models/Chapter.dart';
import '../../../../Foundation/Models/ChapterReference.dart';
import '../../../../Foundation/Views/LoadingColumn.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../InheritedBlocs.dart';
import 'package:flutter/material.dart';

import 'VerseText.dart';

class DismissableChapterViewer extends StatelessWidget {
  final Chapter chapter;
  final Chapter previousChapter;
  final Chapter nextChapter;
  final Book book;
  final int verseNumber;
  final bool shouldHaveBackgrounds;
  final bool showVerseNumbers;
  final Function scrollToVerseMethod;
  final bool showReferences;

  DismissableChapterViewer({
    this.chapter,
    this.book,
    this.shouldHaveBackgrounds,
    this.showVerseNumbers,
    this.verseNumber,
    this.scrollToVerseMethod,
    this.previousChapter,
    this.nextChapter,
    this.showReferences,
  });

  Widget build(BuildContext context) {
    return Dismissible(
      secondaryBackground: this.shouldHaveBackgrounds
          ? VerseText(
              book: book,
              chapter: nextChapter,
              verseNumber: 1,
              scrollToVerseMethod: scrollToVerseMethod,
              showReferences: this.showReferences,
            )
          : LoadingColumn(),
      background: this.shouldHaveBackgrounds
          ? VerseText(
              book: book,
              chapter: previousChapter,
              verseNumber: 1,
              scrollToVerseMethod: scrollToVerseMethod,
              showReferences: this.showReferences,
            )
          : LoadingColumn(),
      resizeDuration: null,
      onDismissed: (DismissDirection swipeDetails) async {
        if (swipeDetails == DismissDirection.endToStart) {
          BlocProvider.of<ReaderBloc>(context).add(ReaderGoToChapter(ChapterReference(chapter:this.nextChapter, verseNumber: 1)));
          //InheritedBlocs.of(context).bibleBloc.goToNextChapter(this.chapter);
        } else {
          BlocProvider.of<ReaderBloc>(context).add(ReaderGoToChapter(ChapterReference(chapter:this.previousChapter, verseNumber: 1)));
          //InheritedBlocs.of(context).bibleBloc.goToPreviousChapter(this.chapter);
        }
      },
      child: VerseText(
        book: book,
        chapter: chapter,
        verseNumber: verseNumber,
        scrollToVerseMethod: scrollToVerseMethod,
        showReferences: this.showReferences,
      ),
      key: ValueKey(chapter.number),
    );
  }
}
