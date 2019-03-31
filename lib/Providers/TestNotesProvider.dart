import 'dart:async';

import 'package:bible_bloc/Blocs/notes_bloc.dart';
import 'package:bible_bloc/Providers/INotesProvider.dart';
import 'package:notus/notus.dart';

class TestNotesProvider extends INotesProvider {
  List<Note> _notes = List<Note>();
  @override
  Future<List<Note>> getNotes() {
    var completer = Completer<List<Note>>();
    _notes.add(
      Note(
          doc: NotusDocument(),
          id: 0,
          lastUpdated: DateTime.now().subtract(Duration(days: 2)),
          title: "test note"),
    );
    completer.complete(_notes);

    return completer.future;
  }

  @override
  Future saveNotes(List<Note> notes) async {
    _notes = notes;
  }
}
