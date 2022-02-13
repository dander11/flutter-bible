import 'package:bible_bloc/Feature/Reader/bloc/reader_bloc.dart';
import 'package:bible_bloc/Feature/Reader/bloc/reader_event.dart';
import 'package:bible_bloc/Feature/Reader/bloc/reader_state.dart';
import 'package:bible_bloc/Feature/Reader/bloc/verse_reference_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Foundation/Models/ChapterElements/Verse.dart';
import '../../../Foundation/Models/ChapterReference.dart';
import '../../InheritedBlocs.dart';
import '../../Navigation/AppPages.dart';
import 'HistoryAppBar.dart';

class HistoryIndex extends StatelessWidget {
  const HistoryIndex({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        HistoryAppBar(),
        SliverFillRemaining(
          child: BlocBuilder<ReaderBloc, ReaderState>(
            bloc: BlocProvider.of<ReaderBloc>(context),
            builder: (BuildContext context, ReaderState ReaderState) {
              return ListView.builder(
                itemCount: BlocProvider.of<ReaderBloc>(context).history.length,
                itemBuilder: (context, index) {
                  var reference =
                      BlocProvider.of<ReaderBloc>(context).history[index];
                  return ListTile(
                    onTap: () async {
                      BlocProvider.of<VerseReferenceBloc>(context)
                          .add(ReaderGoToChapter(reference));

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
