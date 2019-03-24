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
