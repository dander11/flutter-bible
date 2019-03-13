import 'package:bible_bloc/InheritedBlocs.dart';
import 'package:bible_bloc/Models/Chapter.dart';
import 'package:bible_bloc/Views/BookDrawer/BookDrawer.dart';
import 'package:bible_bloc/Views/Settings/SettingPopupMenu.dart';
import 'package:flutter/material.dart';

class NotesTopAppBar extends StatelessWidget {
  const NotesTopAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      centerTitle: true,
      title: Text("Notes"),
    );
  }
}
