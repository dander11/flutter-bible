import 'package:bible_bloc/Views/BookDrawer/BooksList.dart';
import 'package:flutter/material.dart';

class BookDrawer extends StatelessWidget {
  BookDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      semanticLabel: "Books",
      child: BooksList(),
    );
  }
}
