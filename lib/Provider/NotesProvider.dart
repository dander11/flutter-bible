import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bible_bloc/Blocs/notes_bloc.dart';
import 'package:bible_bloc/Provider/INotesProvider.dart';
import 'package:notus/notus.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class NotesProvider extends INotesProvider {
  List<Note> _notes = List<Note>();
  @override
  Future<List<Note>> getNotes() async {
    List<Note> notes = List<Note>();
    final directory = await getApplicationDocumentsDirectory();
    Directory notesDir = Directory('${directory.path}/notes/');
    var exists = notesDir.existsSync();
    if (!exists) {
      notesDir.createSync(recursive: true);
    }
    for (File file in await notesDir
        .list(recursive: false)
        .where((f) => f is File)
        .toList()) {
      var contents = file.readAsStringSync();
      var doc = NotusDocument.fromJson(jsonEncode(contents));
      var id = basename(file.path).split('.')[0];
      notes.add(
        Note(
          id: int.parse(id),
          title: "test",
          doc: doc,
          lastUpdated: DateTime.now(),
        ),
      );
    }

    return notes;
  }

  @override
  Future saveNotes(List<Note> notes) async {
    final directory = await getApplicationDocumentsDirectory();
    for (var note in notes) {
      var file = File(
          '${directory.path}/notes/${note.id}_${note.title}_${note.lastUpdated.toString()}.txt');
      var existingPath = await _getFilePathWithId(note.id);
      if (existingPath.isEmpty ||
          !existingPath.contains(note.title) ||
          !existingPath.contains(note.lastUpdated.toString())) {
        File existingFile = File(existingPath);
        existingFile.deleteSync();
        file = await file.create(recursive: true);
        file.writeAsString(note.doc.toJson().toString());
      }
    }
  }

  Future<String> _getFilePathWithId(int id) async {
    final directory = await getApplicationDocumentsDirectory();
    Directory notesDir = Directory('${directory.path}/notes/');
    var file = await notesDir
        .list(recursive: false)
        .where((f) => f is File)
        .firstWhere((f) => int.parse(basename(f.path).split('_')[0]) == id,
            orElse: () => File(''));
    return file.path;
  }
}
