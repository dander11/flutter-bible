import 'package:bible_bloc/Views/Notes/NoteTaker.dart';
import 'package:bible_bloc/Views/SearchPage/BibleSearchDelegate.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BibleBottomNavigationBar extends StatelessWidget {
  const BibleBottomNavigationBar({
    Key key,
    BuildContext context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) {
        switch (index) {
          case 0:
            break;
          case 1:
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return NotePage();
            }));
            break;
          case 2:
            showSearch(
              context: context,
              delegate: BibleSearchDelegate(),
            );
            break;
          default:
        }
      },
      items: [
        BottomNavigationBarItem(
          title: Text("Bible"),
          icon: Icon(Icons.library_books),
        ),
        BottomNavigationBarItem(
          title: Text("Notes"),
          icon: Icon(MdiIcons.notebook),
        ),
        BottomNavigationBarItem(
          title: Text("Search"),
          icon: Icon(Icons.search),
        ),
      ],
    );
  }
}
