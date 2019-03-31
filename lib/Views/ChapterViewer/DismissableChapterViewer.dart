import 'package:bible_bloc/InheritedBlocs.dart';
import 'package:bible_bloc/Models/Book.dart';
import 'package:bible_bloc/Models/Chapter.dart';
import 'package:bible_bloc/Models/ChapterElements/IChapterElement.dart';
import 'package:bible_bloc/Views/ChapterViewer/VerseText.dart';
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
      secondaryBackground: this._getNextChapter(context),
      background: this._getPrevChapter(context),
      resizeDuration: null,
      onDismissed: (DismissDirection swipeDetails) async {
        if (swipeDetails == DismissDirection.endToStart) {
          var nextChapter =
              await InheritedBlocs.of(context).bibleBloc.nextChapter.last;
          InheritedBlocs.of(context).bibleBloc.currentChapter.add(nextChapter);
        } else {
          var previousChapter =
              await InheritedBlocs.of(context).bibleBloc.previousChapter.last;
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

  _getPrevChapter(context) {
    return StreamBuilder<Chapter>(
        stream: InheritedBlocs.of(context).bibleBloc.previousChapter,
        builder: (context, snapshot) {
          return new DismissableChapterViewer(
            chapter: snapshot.data,
            book: snapshot.data.book,
            addBackgrounds: false,
            showVerseNumbers: this.showVerseNumbers,
          );
        });
  }

  _getNextChapter(context) {
    return StreamBuilder<Chapter>(
        stream: InheritedBlocs.of(context).bibleBloc.nextChapter,
        builder: (context, snapshot) {
          return new DismissableChapterViewer(
            chapter: snapshot.data,
            book: snapshot.data.book,
            addBackgrounds: false,
            showVerseNumbers: this.showVerseNumbers,
          );
        });
  }
}
