import 'package:bible_bloc/Foundation/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:after_layout/after_layout.dart';

class VerseText extends StatefulWidget {
  final Book book;
  final Chapter chapter;
  final Function scrollToVerseMethod;
  final int verseNumber;
  final bool showReferences;

  const VerseText(
      {Key key,
      @required this.book,
      @required this.chapter,
      this.verseNumber,
      this.scrollToVerseMethod,
      this.showReferences})
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
    List<InlineSpan> versesText = List<InlineSpan>();

    for (IChapterElement verse in chapter.elements) {
      versesText.add(verse.toTextSpanWidget(context));
    }
    var expandedChapterText = _flattenTextSpans(versesText);

    if (!widget.showReferences) {
      expandedChapterText.removeWhere((span) => span is WidgetSpan);
    }

    TextSpan chapterText = TextSpan(
      children: expandedChapterText,
      style: Theme.of(context).textTheme.body2,
    );

    var width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text.rich(
          chapterText,
        ),
      ),
    );
    return Container(
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SelectableText.rich(
          chapterText,
        ),
      ),
    );
  }

  List<InlineSpan> _flattenTextSpans(List<InlineSpan> iterable) {
    return iterable
        .expand((InlineSpan e) => e.children != null && e.children.length > 0
            ? _flattenTextSpans(e.children.whereType<InlineSpan>().toList())
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
