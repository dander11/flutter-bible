import 'package:bible_bloc/Blocs/notes_bloc.dart';

abstract class INotesProvider {
  Future<List<Note>> getNotes();

  Future saveNotes(List<Note> notes);
}
