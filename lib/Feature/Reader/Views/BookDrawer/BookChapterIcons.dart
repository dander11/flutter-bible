import 'package:bible_bloc/Foundation/foundation.dart';
import 'package:flutter/material.dart';

import 'ChapterCircle.dart';

class BookChapterCirclesList extends StatelessWidget {
  const BookChapterCirclesList({
    Key key,
    @required this.context,
    @required this.book,
  }) : super(key: key);

  final BuildContext context;
  final Book book;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: -25.0,
      runSpacing: 10.0,
      children: book.chapters
          .map(
            (chap) => ChapterCircle(
                  book: book,
                  chapter: chap,
                  context: context,
                ),
          )
          .toList(),
    );
  }
}
