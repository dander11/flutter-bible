import 'dart:async';

import 'package:bible_bloc/Providers/INotesProvider.dart';
import 'package:bible_bloc/Providers/NotesProvider.dart';
import 'package:notus/notus.dart';
import 'package:queries/collections.dart';
import 'package:rxdart/rxdart.dart';

class NotesBloc {
  INotesProvider _notesProvider = NotesProvider();

  Sink<Note> get addUpdateNote => _addNoteController.sink;
  final _addNoteController = StreamController<Note>();

  Stream<List<Note>> get savedNotes => _notes.stream;
  final _notes = BehaviorSubject<List<Note>>.seeded(List<Note>());

  Stream<int> get highestNoteId => _highestNoteId.stream;
  final _highestNoteId = BehaviorSubject<int>.seeded(0);

  NotesBloc() {
    loadInitialNotes();
    _addNoteController.stream.listen((newNote) {
      _addOrUpdateNote(newNote);
    });
  }

  dispose() {
    _addNoteController.close();
    _notes.close();
    _highestNoteId.close();
  }

  void _addOrUpdateNote(Note newNote) async {
    var currentNotes = _notes.value;
    if (currentNotes.any((n) => n.id == newNote.id)) {
      var noteToUpdate = currentNotes.firstWhere((n) => n.id == newNote.id);
      noteToUpdate.doc = newNote.doc;
      noteToUpdate.lastUpdated = newNote.lastUpdated;
      noteToUpdate.title = newNote.title;
    } else if (newNote.id != null) {
      var newNotes = currentNotes.toList();
      newNotes.add(newNote);
      _notes.add(newNotes);
    } else {
      var newNotes = currentNotes.toList();
      var highestId = Collection(newNotes).max$1((n) => n.id).toInt();
      var newNoteWithId = Note(
        doc: newNote.doc,
        lastUpdated: newNote.lastUpdated,
        title: newNote.title,
        id: highestId + 1,
      );
      newNotes.add(newNoteWithId);
      _notes.add(newNotes);
    }
    _setHighestId();
    _saveNotesToFile();
  }

  void _saveNotesToFile() async {
    var notesToSave = _notes.value;
    _notesProvider.saveNotes(notesToSave);
  }

  Future loadInitialNotes() async {
    var notes = await _notesProvider.getNotes();
    if (notes.length > 0) {
      var highestId = Collection(notes).max$1((n) => n.id).toInt();
      _highestNoteId.add(highestId);
    }
    _notes.add(notes);
  }

  void _setHighestId() {
    if (_notes.value.length > 0) {
      var highestId = Collection(_notes.value).max$1((n) => n.id).toInt();
      _highestNoteId.add(highestId);
    }
  }
}

class Note {
  String title;
  DateTime lastUpdated;
  final int id;
  NotusDocument doc;
  Note({this.id, this.title, this.doc, this.lastUpdated});
}
