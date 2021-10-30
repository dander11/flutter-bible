import '../../../Foundation/Models/Book.dart';
import '../../../Foundation/Models/Chapter.dart';
import '../../../Foundation/Models/ChapterElements/IChapterElement.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:after_layout/after_layout.dart';

class VerseText extends StatefulWidget {
  final Book book;
  final Chapter chapter;
  final Function scrollToVerseMethod;
  final int verseNumber;

  const VerseText(
      {Key key,
      @required this.book,
      @required this.chapter,
      this.verseNumber,
      this.scrollToVerseMethod})
      : super(key: key);

  @override
  _VerseTextState createState() => _VerseTextState(
        scrollToVerseMethod: scrollToVerseMethod,
        book: book,
        chapter: chapter,
        verseNumber: verseNumber,
      );
}

class _VerseTextState extends State<VerseText>
    with AfterLayoutMixin<VerseText> {
  final Book book;
  final Chapter chapter;
  final TextSpan chapterText;
  final Function scrollToVerseMethod;
  final int verseNumber;

  _VerseTextState(
      {this.book,
      this.chapter,
      this.chapterText,
      this.scrollToVerseMethod,
      this.verseNumber});
  @override
  Widget build(BuildContext context) {
    TextSpan chapterText = TextSpan(
      children: [],
      style: Theme.of(context).textTheme.bodyText2,
    );
    for (IChapterElement verse in chapter.elements) {
      chapterText.children.add(verse.toTextSpanWidget(context));
    }
    var expandedChapterText = _flattenTextSpans(chapterText.children);
    chapterText.children.clear();
    chapterText.children.addAll(expandedChapterText);

    var width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
          text: chapterText,
        ),
      ),
    );
  }

  List<TextSpan> _flattenTextSpans(List<TextSpan> iterable) {
    return iterable
        .expand((TextSpan e) => e.children != null && e.children.length > 0
            ? _flattenTextSpans(e.children)
            : [e])
        .toList();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (scrollToVerseMethod != null) {
      scrollToVerseMethod();
    }
  }
}
