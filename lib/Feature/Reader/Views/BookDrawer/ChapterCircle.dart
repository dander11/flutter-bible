import 'package:bible_bloc/Feature/InheritedBlocs.dart';
import 'package:bible_bloc/Foundation/foundation.dart';
import 'package:flutter/material.dart';

class ChapterCircle extends StatelessWidget {
  const ChapterCircle({
    Key key,
    @required this.context,
    @required this.chapter,
    @required this.book,
  }) : super(key: key);

  final BuildContext context;
  final Chapter chapter;
  final Book book;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(
        chapter.number.toString(),
        style: Theme.of(context).textTheme.display1,
      ),
      shape: CircleBorder(),
      padding: EdgeInsets.all(8.0),
      elevation: 0.0,
      onPressed: () {
        InheritedBlocs.of(context)
            .bibleBloc
            .currentChapterReference
            .add(ChapterReference(chapter: chapter));
        Navigator.of(context).pop();
      },
    );
  }
}
