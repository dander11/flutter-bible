import 'package:bible_bloc/InheritedBlocs.dart';
import 'package:bible_bloc/Models/ChapterElements/Verse.dart';

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
          return ListTile(
            title: Text(verse.text),
            subtitle: Text(
                "${verse.chapter.book.name} ${verse.chapter.number}:${verse.number}"),
            onTap: () async {
              InheritedBlocs.of(context)
                  .bibleBloc
                  .currentChapter
                  .add(verse.chapter);
              Navigator.of(context).pop();
            },
          );
        },
      ),
    );
  }
}
