import 'package:bible_bloc/Blocs/notes_bloc.dart';
import 'package:bible_bloc/InheritedBlocs.dart';
import 'package:bible_bloc/Views/Notes/NoteTaker.dart';
import 'package:bible_bloc/main.dart';
import 'package:flutter/material.dart';

class NotesIndex extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Note>>(
      stream: InheritedBlocs.of(context).notesBloc.savedNotes,
      initialData: [],
      builder: (context, snapshot) {
        var notes = snapshot.data;
        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            var note = notes[index];
            var lastUpdated = note.lastUpdated.toLocal();
            return ListTile(
              onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return NotePage(
                          note: note,
                        );
                      },
                    ),
                  ),
              title: Text(note.title),
              subtitle: Text(
                  "${lastUpdated.month}/${lastUpdated.day}/${lastUpdated.year}"),
            );
          },
        );
      },
    );
  }
}
