import 'package:bible_bloc/InheritedBlocs.dart';
import 'package:bible_bloc/Models/Chapter.dart';
import 'package:bible_bloc/Views/BookDrawer/BookDrawer.dart';
import 'package:bible_bloc/Views/Settings/SettingPopupMenu.dart';
import 'package:flutter/material.dart';

class BibleReaderAppBar extends StatelessWidget {
  const BibleReaderAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      centerTitle: true,
      title: GestureDetector(
        onTap: () {
          showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Container(child: BooksList());
              });
        },
        child: StreamBuilder<Chapter>(
          stream: InheritedBlocs.of(context).bibleBloc.chapter,
          builder: (BuildContext context, AsyncSnapshot<Chapter> snapshot) {
            if (snapshot.hasData) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${snapshot.data.book.name} ${snapshot.data.number}"),
                  Icon(Icons.arrow_drop_down)
                ],
              );
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("Select Chapter"), Icon(Icons.arrow_drop_down)],
              );
            }
          },
        ),
      ),
      actions: <Widget>[
        SettingsPopupMenu(),
      ],
    );
  }
}
