import 'dart:collection';
import '../../../../Foundation/Models/Chapter.dart';
import '../../../../Foundation/Models/ChapterElements/Verse.dart';
import '../../../../Foundation/Models/SearchQuery.dart';
import '../../../../Foundation/Views/LoadingColumn.dart';

import '../../../InheritedBlocs.dart';
import 'package:flutter/material.dart';
import 'package:queries/collections.dart';

import 'SearchFilter.dart';
import 'SearchResults.dart';

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
      /* bottomNavigationBar: BibleBottomNavigationBar(
        context: context,
      ), */
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
                  .subtitle1
                  .copyWith(color: Colors.red.shade300),
            ),
          ),
          //BibleBottomNavigationBar(),
        ],
      );
    }
    InheritedBlocs.of(context)
        .searchBloc
        .searchTerm
        .add(SearchQuery(queryText: query, book: ""));

    InheritedBlocs.of(context)
        .searchBloc
        .suggestionSearchTerm
        .add(SearchQuery(queryText: query, book: ""));

    return Column(
      children: <Widget>[
        StreamBuilder<UnmodifiableListView<Verse>>(
          stream: InheritedBlocs.of(context)
              .searchBloc
              .suggestionSearchearchResults,
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
              child: SearchFilter(query: query, books: books),
            );
          },
        ),
        StreamBuilder<UnmodifiableListView<Verse>>(
          stream: InheritedBlocs.of(context).searchBloc.searchResults,
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
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Collection(snapshot.data)
                              .select((v) => v.chapter.book)
                              .distinct()
                              .count() >
                          1
                      ? Text("")
                      : Text(
                          " in ${Collection(snapshot.data).select((v) => v.chapter.book).distinct().toList().first.name}",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                ],
              ),
            );
          }, initialData: null,
        ),
        Divider(),
        StreamBuilder(
          stream: InheritedBlocs.of(context).searchBloc.searchResults,
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
                        .subtitle1
                        .copyWith(color: Colors.red.shade300),
                  ),
                ],
              );
            } else {
              final results = snapshot.data;
              return SearchResults(results: results);
            }
          }, initialData: null,
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Scaffold(
      body: searchResultsBody(context: context),
      /* bottomNavigationBar: BibleBottomNavigationBar(
        context: context,
      ), */
    );
  }
}
