import 'dart:collection';

import 'package:bible_bloc/InheritedBlocs.dart';
import 'package:bible_bloc/Models/Chapter.dart';
import 'package:bible_bloc/Models/ChapterElements/Verse.dart';
import 'package:bible_bloc/Models/SearchQuery.dart';

import 'package:bible_bloc/Views/SearchPage/SearchFilter.dart';
import 'package:bible_bloc/Views/SearchPage/SearchResults.dart';
import 'package:bible_bloc/main.dart';
import 'package:flutter/material.dart';
import 'package:queries/collections.dart';

class BibleSearchDelegate extends SearchDelegate<Chapter> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Scaffold(
      body: searchResultsBody(context: context),
    );
  }

  Widget searchResultsBody({BuildContext context}) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
              textScaleFactor: 1.2,
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(color: Colors.red.shade300),
            ),
          ),
          //BibleBottomNavigationBar(),
        ],
      );
    }
    InheritedBlocs.of(context)
        .bibleBloc
        .searchTerm
        .add(SearchQuery(queryText: query, book: ""));

    InheritedBlocs.of(context)
        .bibleBloc
        .suggestionSearchTerm
        .add(SearchQuery(queryText: query, book: ""));

    return Column(
      children: <Widget>[
        StreamBuilder<UnmodifiableListView<Verse>>(
          stream:
              InheritedBlocs.of(context).bibleBloc.suggestionSearchearchResults,
          initialData: UnmodifiableListView([]),
          builder: (BuildContext context,
              AsyncSnapshot<UnmodifiableListView<Verse>> snapshot) {
            if (!snapshot.hasData || snapshot.data.length == 0) {
              return Container();
            }
            final books = Collection(snapshot.data)
                .select((verse) => verse.chapter.book)
                .toList();
            return Padding(
              padding: const EdgeInsets.fromLTRB(17.0, 0.0, 17.0, 0.0),
              child: new SearchFilter(query: query, books: books),
            );
          },
        ),
        StreamBuilder<UnmodifiableListView<Verse>>(
          stream: InheritedBlocs.of(context).bibleBloc.searchResults,
          builder: (BuildContext context,
              AsyncSnapshot<UnmodifiableListView<Verse>> snapshot) {
            if (!snapshot.hasData || snapshot.data.length == 0) {
              return Row();
            }
            return Padding(
              padding: const EdgeInsets.fromLTRB(17.0, 0.0, 17.0, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "${snapshot.data.length} Results",
                    style: Theme.of(context).textTheme.body1,
                  ),
                  Collection(snapshot.data)
                              .select((v) => v.chapter.book)
                              .distinct()
                              .count() >
                          1
                      ? Text("")
                      : Text(
                          " in ${Collection(snapshot.data).select((v) => v.chapter.book).distinct().toList().first.name}",
                          style: Theme.of(context).textTheme.body1,
                        ),
                ],
              ),
            );
          },
        ),
        Divider(),
        StreamBuilder(
          stream: InheritedBlocs.of(context).bibleBloc.searchResults,
          builder:
              (context, AsyncSnapshot<UnmodifiableListView<Verse>> snapshot) {
            if (!snapshot.hasData) {
              return LoadingColumn();
            } else if (snapshot.data.length == 0) {
              return Column(
                children: <Widget>[
                  Text(
                    "No Results Found.",
                    style: Theme.of(context)
                        .textTheme
                        .subhead
                        .copyWith(color: Colors.red.shade300),
                  ),
                ],
              );
            } else {
              final results = snapshot.data;
              return new SearchResults(results: results);
            }
          },
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Scaffold(
      body: Column(),
      //bottomNavigationBar: BibleBottomNavigationBar(),
    );
  }
}
