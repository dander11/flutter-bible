import 'package:bible_bloc/InheritedBlocs.dart';
import 'package:bible_bloc/Views/ChapterViewer/DismissableChapterViewer.dart';
import 'package:bible_bloc/Views/LoadingColumn.dart';
import 'package:flutter/material.dart';

class Reader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: InheritedBlocs.of(context).bibleBloc.chapter,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return StreamBuilder<bool>(
            stream: InheritedBlocs.of(context).settingsBloc.showVerseNumbers,
            initialData: false,
            builder: (BuildContext context, AsyncSnapshot<bool> setting) {
              if (setting.hasData) {
                return DismissableChapterViewer(
                  addBackgrounds: true,
                  book: snapshot.data.book,
                  chapter: snapshot.data,
                  showVerseNumbers: setting.data,
                );
              } else {
                return DismissableChapterViewer(
                  addBackgrounds: true,
                  book: snapshot.data.book,
                  chapter: snapshot.data,
                  showVerseNumbers: true,
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
