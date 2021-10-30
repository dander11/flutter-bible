import '../../../Reader/bloc/reader_bloc.dart';
import '../../../Reader/bloc/reader_event.dart';
import '../../../../Foundation/Models/Book.dart';
import '../../../../Foundation/Models/Chapter.dart';
import '../../../../Foundation/Models/ChapterReference.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../InheritedBlocs.dart';
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
        style: Theme.of(context).textTheme.subtitle1,
      ),
      shape: CircleBorder(),
      padding: EdgeInsets.all(8.0),
      elevation: 0.0,
      onPressed: () {
        BlocProvider.of<ReaderBloc>(context).add(ReaderGoToChapter(ChapterReference(chapter: chapter)));
        //context.read<ReaderBloc>(;
        /* InheritedBlocs.of(context)
            .bibleBloc
            .currentChapterReference
            .add(ChapterReference(chapter: chapter)); */
        Navigator.of(context).pop();
      },
    );
  }
}
