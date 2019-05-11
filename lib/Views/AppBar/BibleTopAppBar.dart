import 'package:bible_bloc/InheritedBlocs.dart';
import 'package:bible_bloc/Models/ChapterReference.dart';
import 'package:bible_bloc/Views/BookDrawer/BooksList.dart';
import 'package:bible_bloc/Views/SearchPage/BibleSearchDelegate.dart';
import 'package:bible_bloc/Views/Settings/SettingPopupMenu.dart';
import 'package:flutter/material.dart';

class BibleReaderAppBar extends StatelessWidget {
  final String title;
  const BibleReaderAppBar({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      centerTitle: true,
      /* leading: IconButton(
        icon: Icon(Icons.search),
        onPressed: () => showSearch(
              context: context,
              delegate: BibleSearchDelegate(),
            ),
      ), */
      title: GestureDetector(
        onTap: () {
          showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Container(child: BooksList());
              });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(title),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      /* actions: <Widget>[
        SettingsPopupMenu(),
      ],*/
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () => showSearch(
                context: context,
                delegate: BibleSearchDelegate(),
              ),
        ),
      ],
    );
  }
}
