
import 'package:bible_bloc/Feature/InheritedBlocs.dart';
import 'package:bible_bloc/Feature/Navigation/navigation_feature.dart';
import 'package:bible_bloc/Foundation/foundation.dart';
import 'package:flutter/material.dart';

import 'NoteTile.dart';

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
