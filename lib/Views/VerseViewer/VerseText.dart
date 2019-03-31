import 'package:bible_bloc/Models/Book.dart';
import 'package:bible_bloc/Models/Chapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class VerseText extends StatelessWidget {
  const VerseText({
    Key key,
    @required this.book,
    @required this.chapter,
    @required this.chapterText,
  }) : super(key: key);

  final Book book;
  final Chapter chapter;
  final TextSpan chapterText;
  //final List<RichText> chapterText;

  @override
  Widget build(BuildContext context) {
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
}
