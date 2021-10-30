
import '../Models/Note.dart';

abstract class INotesProvider {
  Future<List<Note>> getNotes();

  Future saveNotes(List<Note> notes);
}
