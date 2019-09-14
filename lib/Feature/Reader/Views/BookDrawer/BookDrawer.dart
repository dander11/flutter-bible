import 'package:flutter/material.dart';
import 'BooksList.dart';

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
