import 'package:bible_bloc/Models/Book.dart';
import 'package:bible_bloc/Models/Chapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:after_layout/after_layout.dart';

class VerseText extends StatefulWidget {
  final Book book;
  final Chapter chapter;
  final TextSpan chapterText;
  final Function scrollToVerseMethod;
  final int verseNumber;

  const VerseText(
      {Key key,
      @required this.book,
      @required this.chapter,
      @required this.chapterText,
      this.verseNumber,
      this.scrollToVerseMethod})
      : super(key: key);

  @override
  _VerseTextState createState() =>
      _VerseTextState(scrollToVerseMethod: scrollToVerseMethod);
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
    var width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
          text: widget.chapterText,
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    scrollToVerseMethod();
  }
}
