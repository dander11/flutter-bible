import 'dart:async';
import '../../Foundation/Models/ChapterElements/Verse.dart';
import '../../Foundation/Models/SearchQuery.dart';
import '../../Foundation/Search/ISearchProvider.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:collection';

class SearchBloc {
  ISearchProvider _searchProvider;

  Sink<SearchQuery> get searchTerm => _searchTermController.sink;
  final _searchTermController = StreamController<SearchQuery>();

  Stream<UnmodifiableListView<Verse>> get searchResults =>
      _searchResultsSubject.stream;
  final _searchResultsSubject = BehaviorSubject<UnmodifiableListView<Verse>>();

  Sink<SearchQuery> get suggestionSearchTerm =>
      _suggestionSearchTermController.sink;
  final _suggestionSearchTermController = StreamController<SearchQuery>();

  Stream<UnmodifiableListView<Verse>> get suggestionSearchearchResults =>
      _suggestionSearchResultsSubject.stream;
  final _suggestionSearchResultsSubject =
      BehaviorSubject<UnmodifiableListView<Verse>>();

  SearchBloc(ISearchProvider searchProvider) {
    _searchProvider = searchProvider;
    _searchProvider.init();

    _searchTermController.stream.listen((search) {
      _updateSearchResults(search);
    });

    _suggestionSearchTermController.stream.listen((search) {
      _updateSearchSuggestions(search);
    });
  }

  void _updateSearchSuggestions(SearchQuery search) {
    if (search.queryText.length > 2) {
      var booksToSearch =
          search.book.isNotEmpty ? <String>[search.book] : <String>[];
      _searchProvider
          .getSearchResults(search.queryText, booksToSearch)
          .then((results) {
        _suggestionSearchResultsSubject.add(UnmodifiableListView(results));
      });
    }
  }

  void _updateSearchResults(SearchQuery search) {
    if (search.queryText.length > 2) {
      var booksToSearch =
          search.book.isNotEmpty ? <String>[search.book] : <String>[];
      _searchProvider
          .getSearchResults(search.queryText, booksToSearch)
          .then((results) {
        _searchResultsSubject.add(UnmodifiableListView(results));
      });
    }
  }

  dispose() {
    _searchTermController.close();
    _suggestionSearchTermController.close();
  }
}
