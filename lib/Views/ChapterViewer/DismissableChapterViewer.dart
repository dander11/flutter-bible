import 'package:bible_bloc/InheritedBlocs.dart';
import 'package:bible_bloc/Models/Book.dart';
import 'package:bible_bloc/Models/Chapter.dart';
import 'package:bible_bloc/Models/ChapterElements/IChapterElement.dart';
import 'package:bible_bloc/Views/ChapterViewer/VerseText.dart';
import 'package:bible_bloc/Views/LoadingColumn.dart';
import 'package:flutter/material.dart';

class DismissableChapterViewer extends StatelessWidget {
  final Chapter chapter;
  final Book book;
  final bool addBackgrounds;
  final bool showVerseNumbers;

  DismissableChapterViewer({
    this.chapter,
    this.book,
    this.addBackgrounds,
    this.showVerseNumbers,
  });

  Widget build(BuildContext context) {
    TextSpan chapterText = TextSpan(
      children: [],
      style: Theme.of(context).textTheme.body2,
    );
    for (IChapterElement verse in chapter.elements) {
      chapterText.children.add(verse.toTextSpanWidget(context));
    }
    var expandedChapterText = _flattenTextSpans(chapterText.children);
    chapterText.children.clear();
    chapterText.children.addAll(expandedChapterText);

    return new Dismissible(
      secondaryBackground: this.addBackgrounds
          ? _NextChapter(showVerseNumbers: showVerseNumbers)
          : LoadingColumn(),
      background: this.addBackgrounds
          ? _PreviousChapter(showVerseNumbers: showVerseNumbers)
          : LoadingColumn(),
      resizeDuration: null,
      onDismissed: (DismissDirection swipeDetails) async {
        if (swipeDetails == DismissDirection.endToStart) {
          var nextChapter =
              await InheritedBlocs.of(context).bibleBloc.nextChapter.first;
          InheritedBlocs.of(context).bibleBloc.currentChapter.add(nextChapter);
        } else {
          var previousChapter =
              await InheritedBlocs.of(context).bibleBloc.previousChapter.first;
          InheritedBlocs.of(context)
              .bibleBloc
              .currentChapter
              .add(previousChapter);
        }
      },
      child:
          new VerseText(book: book, chapter: chapter, chapterText: chapterText),
      key: new ValueKey(chapter.number),
    );
  }

  List<TextSpan> _flattenTextSpans(List<TextSpan> iterable) {
    return iterable
        .expand((TextSpan e) => e.children != null && e.children.length > 0
            ? _flattenTextSpans(e.children)
            : [e])
        .toList();
  }
}

class _NextChapter extends StatelessWidget {
  const _NextChapter({
    Key key,
    @required this.showVerseNumbers,
  }) : super(key: key);

  final bool showVerseNumbers;

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
  }) : super(key: key);

  final bool showVerseNumbers;

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
          );
        } else {
          return LoadingColumn();
        }
      },
    );
  }
}
