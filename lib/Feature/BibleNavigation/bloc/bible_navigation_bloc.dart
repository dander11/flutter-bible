import 'dart:async';

import '../../../Foundation/Models/Book.dart';
import '../../../Foundation/Provider/IBibleProvider.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bible_navigation_event.dart';
part 'bible_navigation_state.dart';

class BibleNavigationBloc extends Bloc<BibleNavigationEvent, BibleNavigationState> {
  List<Book> _books;
  final IBibleProvider importer;

  BibleNavigationBloc(this.importer) : super(BibleNavigationInitial());

  @override
  Stream<BibleNavigationState> mapEventToState(
    BibleNavigationEvent event,
  ) async* {
    if (event is BibleNavigationInitial) {
      _books = await _getBooks();
      yield BibleNavigationLoaded(_books);
    }
  }

  
    Future<Null> _getBooks() async {
    await importer.init();
    return await importer.getAllBooks();
  }
}
