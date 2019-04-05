import 'package:bible_bloc/InheritedBlocs.dart';
import 'package:bible_bloc/Models/ChapterReference.dart';
import 'package:bible_bloc/Views/ChapterViewer/DismissableChapterViewer.dart';
import 'package:bible_bloc/Views/LoadingColumn.dart';
import 'package:flutter/material.dart';

class Reader extends StatelessWidget {
  final Function scrollToVerseMethod;

  const Reader({Key key, this.scrollToVerseMethod}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ChapterReference>(
      stream: InheritedBlocs.of(context).bibleBloc.chapterReference,
      builder: (BuildContext context,
          AsyncSnapshot<ChapterReference> chapterReference) {
        if (chapterReference.hasData) {
          return StreamBuilder<bool>(
            stream: InheritedBlocs.of(context).settingsBloc.showVerseNumbers,
            initialData: false,
            builder: (BuildContext context, AsyncSnapshot<bool> setting) {
              if (setting.hasData) {
                return DismissableChapterViewer(
                  addBackgrounds: true,
                  book: chapterReference.data.chapter.book,
                  chapter: chapterReference.data.chapter,
                  showVerseNumbers: setting.data,
                  scrollToVerseMethod: scrollToVerseMethod,
                );
              } else {
                return DismissableChapterViewer(
                  addBackgrounds: true,
                  book: chapterReference.data.chapter.book,
                  chapter: chapterReference.data.chapter,
                  showVerseNumbers: true,
                  scrollToVerseMethod: scrollToVerseMethod,
                );
              }
            },
          );
        } else {
          return new LoadingColumn();
        }
      },
    );
  }
}
