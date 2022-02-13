import 'dart:async';

import 'package:bible_bloc/Feature/Reader/bloc/verse_reference_bloc.dart';
import 'package:flutter/services.dart';
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
        useRootNavigator: true,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return FractionallySizedBox(
              heightFactor: .8,
              child: CustomScrollView(
                controller: _controller,
                slivers: <Widget>[
                  BlocBuilder<VerseReferenceBloc, ReaderState>(
                      bloc: BlocProvider.of<VerseReferenceBloc>(context),
                      builder: (context, state) {
                        if (state is ReaderLoaded) {
                          return SliverAppBar(
                            pinned: true,
                            centerTitle: true,
                            title: Text(
                                "${state.currentChapterReference.chapter.book.name} ${state.currentChapterReference.chapter.number.toString()}:${state.currentChapterReference.verseNumber.toString()}"),
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

  openChapterReference(
      BuildContext context, String referenceId, Offset globalPostiion) {
    bool hasFired = false;
    StreamSubscription<CrossReference> listener;

    listener = this.bibleBloc.crossReference.listen((value) {
      var reference = this.bibleBloc.crossReference.value;
      if (!hasFired && reference.id == referenceId) {
        hasFired = true;
        showMenu(
            context: context,
            position: RelativeRect.fromLTRB(
                globalPostiion.dx, globalPostiion.dy, globalPostiion.dx, 0),
            /* 
        RelativeRect.fromRect(
            globalPostiion & Size(40, 40), // smaller rect, the touch area
            Offset.zero & Size(40, 40) // Bigger rect, the entire screen
            ), */
            items: <PopupMenuItem>[
              for (var ref
                  in reference.elements.whereType<VerseReferenceElement>())
                PopupMenuItem(
                  onTap: () {
                    HapticFeedback.vibrate();
                    this.openVerseReferenceInSheet(context, ref);
                  },
                  child: Text.rich(
                    ref.toInlineSpan(context),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                )
            ]);
        listener.cancel();
      }
    });
    this.bibleBloc.addChapterReferenceFromId(referenceId);
    var snackBar = StreamBuilder<CrossReference>(
      stream: this.bibleBloc.crossReference.stream,
      builder:
          (BuildContext snackContext, AsyncSnapshot<CrossReference> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        var reference = this.bibleBloc.crossReference.value;
        /*  return Container(
          child: Text.rich(
            reference.toInlineSpan(context),
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ); */
      },
    );

    // Scaffold.of(context).showSnackBar(snackBar);
  }

  openVerseReferenceInSheet(
      BuildContext context, VerseReferenceElement referenceElement) async {
    BlocProvider.of<VerseReferenceBloc>(context)
        .add(GoToVerseReferenceFromNumbers(referenceElement));
    //this.bibleBloc.updatePopupReferenceFromCrossReference(referenceElement);
    this.showReferenceInBottomSheet(context);
  }
}
