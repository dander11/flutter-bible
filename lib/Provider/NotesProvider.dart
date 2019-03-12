import 'dart:async';
import 'dart:io';
import 'package:bible_bloc/Blocs/notes_bloc.dart';
import 'package:bible_bloc/Provider/INotesProvider.dart';
import 'package:notus/notus.dart';
import 'package:path_provider/path_provider.dart';

class NotesProvider extends INotesProvider {
  List<Note> _notes = List<Note>();
  @override
  Future<List<Note>> getNotes() async {
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
    final directory = await getApplicationDocumentsDirectory();
    for (var note in notes) {
      var file = File('${directory.path}/notes/${note.id}.txt');
      if (!(await file.exists())) {
        file.create(recursive: true);
      }
      file.writeAsString(note.doc.toJson().toString());
    }
  }
}
