import 'package:bible_bloc/Feature/Reader/bloc/verse_reference_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Foundation/Models/ChapterReference.dart';
import '../Foundation/Views/LoadingColumn.dart';

import 'Navigation/navigation_feature.dart';
import 'Notes/notes_feature.dart';
import 'Reader/bloc/reader_bloc.dart';
import 'Reader/bloc/reader_event.dart';
import 'Reader/bloc/reader_state.dart';
import 'Reader/reader_feature.dart';
import 'Search/search_feature.dart';
import 'Settings/settings_feature.dart';
import '../Foundation/Models/CrossReference.dart';
import '../Foundation/Models/CrossReferenceElements/VerseReferenceElement.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InheritedBlocs extends InheritedWidget {
  InheritedBlocs(
      {Key key,
      this.searchBloc,
      this.bibleBloc,
      this.settingsBloc,
      this.notesBloc,
      this.navigationBloc,
      this.child})
      : super(key: key, child: child);

  final Widget child;
  final BibleBloc bibleBloc;
  final SettingsBloc settingsBloc;
  final NotesBloc notesBloc;
  final NavigationBloc navigationBloc;
  final SearchBloc searchBloc;

  static InheritedBlocs of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedBlocs>();
  }

  @override
  bool updateShouldNotify(InheritedBlocs oldWidget) {
    return true;
  }

  Future<bool> showReferenceInBottomSheet(BuildContext context) {
    ScrollController _controller = ScrollController();
    return showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return FractionallySizedBox(
              heightFactor: .8,
              child: CustomScrollView(
                controller: _controller,
                slivers: <Widget>[
                  BlocBuilder<VerseReferenceBloc, ReaderState>(
                      builder: (context, state) {
                    if (state is ReaderLoaded) {
                      return SliverAppBar(
                        pinned: true,
                        actions: <Widget>[
                          IconButton(
                            icon: Icon(Icons.open_in_new),
                            onPressed: () {
                              BlocProvider.of<ReaderBloc>(context).add(
                                  ReaderGoToChapter(
                                      state.currentChapterReference));

                              Navigator.of(context).pop(true);
                            },
                          )
                        ],
                      );
                    } else {
                      return SliverAppBar(
                        pinned: true,
                        actions: <Widget>[],
                      );
                    }
                  }),
                  SliverToBoxAdapter(child:
                      BlocBuilder<VerseReferenceBloc, ReaderState>(
                          builder: (context, state) {
                    if (state is ReaderLoaded) {
                      return Reader(
                        canSwipeToNextChapter: false,
                        controller: _controller,
                        chapterReference: state.currentChapterReference,
                        showReferences: false,
                      );
                    } else {
                      return LoadingColumn();
                    }
                  })),
                ],
              ));
        });
  }

  openChapterReference(BuildContext context, String referenceId) {
    this.bibleBloc.addChapterReferenceFromId(referenceId);

    var snackBar = SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: StreamBuilder<CrossReference>(
        stream: this.bibleBloc.crossReference.stream,
        builder: (BuildContext snackContext,
            AsyncSnapshot<CrossReference> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          var reference = this.bibleBloc.crossReference.value;
          return Container(
            child: Text.rich(
              reference.toInlineSpan(context),
              style: Theme.of(context).textTheme.bodyText2,
            ),
          );
        },
      ),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }

  openVerseReferenceInSheet(
      BuildContext context, VerseReferenceElement referenceElement) {
    this.bibleBloc.updatePopupReferenceFromCrossReference(referenceElement);
    this.showReferenceInBottomSheet(context);
  }
}
