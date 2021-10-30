import '../../../../Foundation/Models/Book.dart';

import 'package:flutter/material.dart';

import 'BookChapterIcons.dart';

class BookPanel extends StatelessWidget {
  final Book book;
  const BookPanel({Key key, @required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: PageStorageKey(book.name),
      title: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          book.name,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: BookChapterCirclesList(
            book: book,
            context: context,
          ),
        )
      ],
    );
  }
}
