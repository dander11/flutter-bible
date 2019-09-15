import 'package:bible_bloc/Feature/InheritedBlocs.dart';
import 'package:bible_bloc/Feature/Navigation/AppPages.dart';
import 'package:bible_bloc/Foundation/Models/ChapterElements/Verse.dart';
import 'package:bible_bloc/Foundation/Models/ChapterReference.dart';
import 'package:flutter/material.dart';

import 'HistoryAppBar.dart';

class HistoryIndex extends StatelessWidget {
  const HistoryIndex({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        HistoryAppBar(),
        SliverFillRemaining(
          child: StreamBuilder<List<ChapterReference>>(
            stream: InheritedBlocs.of(context).bibleBloc.chapterHistory,
            initialData: [],
            builder: (BuildContext context,
                AsyncSnapshot<List<ChapterReference>> snapshot) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  var reference = snapshot.data[index];
                  return ListTile(
                    onTap: () async {
                      InheritedBlocs.of(context)
                          .bibleBloc
                          .currentPopupChapterReference
                          .add(
                            ChapterReference(
                              chapter: reference.chapter,
                              verseNumber: reference.verseNumber,
                            ),
                          );
                      InheritedBlocs.of(context)
                          .showReferenceInBottomSheet(
                        context,
                      )
                          .then((shouldReturnToReaderPage) {
                        if (shouldReturnToReaderPage != null &&
                            shouldReturnToReaderPage) {
                          InheritedBlocs.of(context)
                              .navigationBloc
                              .nextPage
                              .add(AppPage.readerPage);
                        } else {
                          InheritedBlocs.of(context)
                              .bibleBloc
                              .currentPopupChapterReference
                              .add(null);
                        }
                      });
                    },
                    title: Text(
                        "${reference.chapter.book.name} ${reference.chapter.number}:${reference.verseNumber}"),
                    subtitle: Text(
                      "${reference.chapter.elements.whereType<Verse>().toList()[reference.verseNumber].text}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}
