import 'package:bible_bloc/InheritedBlocs.dart';
import 'package:bible_bloc/Models/ChapterElements/Verse.dart';
import 'package:bible_bloc/Models/ChapterReference.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({Key key, @required this.results, this.controller})
      : super(key: key);

  final UnmodifiableListView<Verse> results;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        controller:
            this.controller == null ? ScrollController() : this.controller,
        itemCount: results.length,
        itemBuilder: (BuildContext context, int index) {
          var verse = results[index];
          return Container(
            decoration: BoxDecoration(
              border: BorderDirectional(
                bottom: BorderSide(color: Colors.white10),
              ),
            ),
            child: ListTile(
              title: Text(verse.text),
              subtitle: Text(
                  "${verse.chapter.book.name} ${verse.chapter.number}:${verse.number}"),
              onTap: () async {
                InheritedBlocs.of(context)
                    .bibleBloc
                    .currentPopupChapterReference
                    .add(
                      ChapterReference(
                        chapter: verse.chapter,
                        verseNumber: verse.number,
                      ),
                    );
                InheritedBlocs.of(context)
                    .showReferenceInBottomSheet(
                  context,
                )
                    .then((shouldReturnToReaderPage) {
                  if (shouldReturnToReaderPage != null &&
                      shouldReturnToReaderPage) {
                    Navigator.of(context).pop();
                  } else {
                    InheritedBlocs.of(context)
                        .bibleBloc
                        .currentPopupChapterReference
                        .add(null);
                  }
                });
                /* InheritedBlocs.of(context).bibleBloc.currentChapterReference.add(
                      ChapterReference(
                        chapter: verse.chapter,
                        verseNumber: verse.number,
                      ),
                    ); 
                Navigator.of(context).pop();*/
              },
            ),
          );
        },
      ),
    );
  }
}
