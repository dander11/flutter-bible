import 'package:bible_bloc/Models/Book.dart';
import 'package:bible_bloc/Models/Chapter.dart';
import 'package:flutter/material.dart';

class VerseText extends StatelessWidget {
  const VerseText({
    Key key,
    @required this.book,
    @required this.chapter,
    @required this.chapterText,
  }) : super(key: key);

  final Book book;
  final Chapter chapter;
  final List<TextSpan> chapterText;

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Expanded(
          child: new SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new RichText(
                    text: new TextSpan(
                      children: chapterText,
                      style: Theme.of(context).textTheme.body2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
