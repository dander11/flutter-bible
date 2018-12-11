import 'package:bible_bloc/InheritedBlocs.dart';
import 'package:bible_bloc/Models/SearchQuery.dart';
import 'package:flutter/material.dart';

class SearchFilter extends StatelessWidget {
  const SearchFilter({
    Key key,
    @required this.query,
    @required this.books,
  }) : super(key: key);

  final String query;
  final List books;

  @override
  Widget build(BuildContext context) {
    var filters = books
        .map(
          (b) => DropdownMenuItem(
                child: Text(b.name),
                value: b.name,
              ),
        )
        .toList();
    filters.insert(
        0,
        DropdownMenuItem(
          child: Text("All"),
          value: "",
        ));
    return DropdownButton(
      hint: Text("Filter by book"),
      isExpanded: true,
      onChanged: (value) {
        InheritedBlocs.of(context)
            .bibleBloc
            .searchTerm
            .add(SearchQuery(queryText: query, book: value));
      },
      items: filters,
    );
  }
}
