import 'package:bible_bloc/InheritedBlocs.dart';
import 'package:bible_bloc/Models/Verse.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({
    Key key,
    @required this.results,
  }) : super(key: key);

  final UnmodifiableListView<Verse> results;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
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
