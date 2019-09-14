import 'package:bible_bloc/Feature/Navigation/navigation_feature.dart';
import 'package:bible_bloc/Feature/Notes/notes_feature.dart';
import 'package:bible_bloc/Feature/Reader/reader_feature.dart';
import 'package:bible_bloc/Feature/Search/search_feature.dart';
import 'package:bible_bloc/Feature/Settings/settings_feature.dart';
import 'package:bible_bloc/Foundation/foundation.dart';
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
    return (context.inheritFromWidgetOfExactType(InheritedBlocs)
        as InheritedBlocs);
  }

  @override
  bool updateShouldNotify(InheritedBlocs oldWidget) {
    return true;
  }

  Future<bool> showReferenceInBottomSheet(BuildContext context) {
    ScrollController _controller = ScrollController();
    return showModalBottomSheet<bool>(
        context: context,
        builder: (BuildContext context) {
          return Container(
              child: CustomScrollView(
            controller: _controller,
            slivers: <Widget>[
              StreamBuilder<ChapterReference>(
                stream:
                    InheritedBlocs.of(context).bibleBloc.popupChapterReference,
                builder: (context, popUpReference) {
                  if (popUpReference.hasData) {
                    return SliverAppBar(
                      pinned: true,
                      actions: <Widget>[
                        IconButton(
                          icon: Icon(Icons.open_in_new),
                          onPressed: () {
                            InheritedBlocs.of(context)
                                .bibleBloc
                                .currentChapterReference
                                .add(
                                  popUpReference.data,
                                );
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
                },
                initialData: null,
              ),
              SliverToBoxAdapter(
                child: StreamBuilder<ChapterReference>(
                    stream: InheritedBlocs.of(context)
                        .bibleBloc
                        .popupChapterReference,
                    builder: (context, reference) {
                      if (reference.hasData) {
                        return Reader(
                          canSwipeToNextChapter: false,
                          controller: _controller,
                          chapterReference: reference.data,
                        );
                      } else {
                        return LoadingColumn();
                      }
                    }, initialData: null,),
              ),
            ],
          ));
        });
  }
}
