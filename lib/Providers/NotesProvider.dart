import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bible_bloc/Blocs/notes_bloc.dart';
import 'package:bible_bloc/Providers/INotesProvider.dart';
import 'package:intl/intl.dart';
import 'package:notus/notus.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class NotesProvider extends INotesProvider {
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
      try {
        var contents = file.readAsStringSync();
        if (contents.isEmpty) {
          continue;
        }
        var json = jsonDecode(contents);
        var doc = NotusDocument.fromJson(json);
        var noteName = basename(file.path).split('.')[0];
        var id = noteName.split('_')[0];
        var title = noteName.split('_')[1];
        var lastUpdated = DateTime.parse(noteName.split('_')[2]);
        notes.add(
          Note(
            id: int.parse(id),
            title: title,
            doc: doc,
            lastUpdated: lastUpdated,
          ),
        );
      } catch (e) {}
    }

    return notes;
  }

  @override
  Future saveNotes(List<Note> notes) async {
    final directory = await getApplicationDocumentsDirectory();
    for (var note in notes) {
      var formatter = DateFormat('yyyy-MM-dd');
      String formatted = formatter.format(note.lastUpdated);
      var file = File(
          '${directory.path}/notes/${note.id}_${note.title}_$formatted.txt');
      var existingPath = await _getFilePathWithId(note.id);
      if (existingPath.isEmpty) {
        file = await file.create(recursive: true);
        file.writeAsString(jsonEncode(note.doc.toJson()));
      } else if (!existingPath.contains(note.title) ||
          !existingPath.contains(formatted)) {
        File existingFile = File(existingPath);
        existingFile.deleteSync();
      } else {
        file.writeAsString(jsonEncode(note.doc.toJson()));
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
