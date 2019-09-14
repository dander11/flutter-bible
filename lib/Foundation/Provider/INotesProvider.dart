
import 'package:bible_bloc/Foundation/Models/Note.dart';

abstract class INotesProvider {
  Future<List<Note>> getNotes();

  Future saveNotes(List<Note> notes);
}
