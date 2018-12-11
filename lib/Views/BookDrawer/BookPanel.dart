import 'package:bible_bloc/Models/Book.dart';
import 'package:bible_bloc/Views/BookDrawer/ChapterCircle.dart';
import 'package:flutter/material.dart';

class BookPanel extends StatelessWidget {
  final Book book;
  const BookPanel({Key key, @required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: new Padding(
        padding: const EdgeInsets.all(10.0),
        child: new Text(
          book.name,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.display1,
        ),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: BookChapterPanel(
            book: book,
            context: context,
          ),
        )
      ],
    );
  }
}

class BookChapterPanel extends StatelessWidget {
  const BookChapterPanel({
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
