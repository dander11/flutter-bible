import 'package:bible_bloc/Blocs/bible_bloc.dart';
import 'package:bible_bloc/Blocs/navigation_bloc.dart';
import 'package:bible_bloc/Blocs/notes_bloc.dart';
import 'package:bible_bloc/Blocs/settings_bloc.dart';
import 'package:flutter/cupertino.dart';

class InheritedBlocs extends InheritedWidget {
  InheritedBlocs(
      {Key key,
      this.bibleBloc,
      this.settingsBloc,
      this.notesBloc,
      this.navigationBloc,
      this.child})
      : super(key: key, child: child);

  final Widget child;
  final BibleBloc bibleBloc;
  final SettingsBloc settingsBloc;
  final NotesBloc notesBloc;
  final NavigationBloc navigationBloc;

  static InheritedBlocs of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(InheritedBlocs)
        as InheritedBlocs);
  }

  @override
  bool updateShouldNotify(InheritedBlocs oldWidget) {
    return true;
  }
}
