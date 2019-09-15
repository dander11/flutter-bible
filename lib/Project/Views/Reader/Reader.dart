import 'package:bible_bloc/Feature/Reader/reader_feature.dart';
import 'package:bible_bloc/Foundation/foundation.dart';
import 'package:flutter/material.dart';

class Reader extends StatelessWidget {
  final ChapterReference chapterReference;
  final Chapter previousChapter;
  final Chapter nextChapter;
  final ScrollController controller;
  final bool canSwipeToNextChapter;

  const Reader(
      {Key key,
      this.chapterReference,
      this.controller,
      this.canSwipeToNextChapter = true,
      this.previousChapter,
      this.nextChapter})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return this.canSwipeToNextChapter
        ? DismissableChapterViewer(
            shouldHaveBackgrounds: true,
            book: chapterReference.chapter.book,
            nextChapter: nextChapter,
            previousChapter: previousChapter,
            chapter: chapterReference.chapter,
            showVerseNumbers: true,
            scrollToVerseMethod: _scrollToVerse,
          )
        : VerseText(
            book: chapterReference.chapter.book,
            chapter: chapterReference.chapter,
            scrollToVerseMethod: _scrollToVerse,
          );
  }

  double _getScrollOffset(int length, int verseNumber) {
    if (length > 0 && verseNumber > 3) {
      return verseNumber / length;
    } else {
      return 0;
    }
  }

  List<IChapterElement> _flattenList(List<IChapterElement> iterable) {
    return iterable
        .expand((IChapterElement e) =>
            e.elements != null && e.elements.length > 0 && !(e is Verse)
                ? _flattenList(e.elements)
                : [e])
        .toList();
  }

  Future<void> _scrollToVerse() async {
    while (!controller.hasClients) {}
    var scrollPosition = controller.position;
    if (scrollPosition.viewportDimension < scrollPosition.maxScrollExtent) {
      var verses =
          _flattenList(chapterReference.chapter.elements).whereType<Verse>();

      var scrollPercentage =
          _getScrollOffset(verses.length, chapterReference.verseNumber);
      var positon = controller.position.maxScrollExtent * scrollPercentage;
      controller.jumpTo(
        positon,
      );
    }
  }
}
