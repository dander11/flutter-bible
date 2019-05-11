import 'package:bible_bloc/Blocs/notes_bloc.dart';
import 'package:bible_bloc/InheritedBlocs.dart';
import 'package:bible_bloc/Views/AppBar/NotesTopAppBar.dart';
import 'package:bible_bloc/Views/Notes/NoteTile.dart';
import 'package:flutter/material.dart';

class NotesIndex extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        NotesTopAppBar(),
        SliverFillRemaining(
          child: StreamBuilder<List<Note>>(
            stream: InheritedBlocs.of(context).notesBloc.savedNotes,
            initialData: [],
            builder: (context, snapshot) {
              var notes = snapshot.data;
              return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  var note = notes[index];
                  return NoteTile(note: note);
                },
              );
            },
          ),
        )
      ],
    );
  }
}
