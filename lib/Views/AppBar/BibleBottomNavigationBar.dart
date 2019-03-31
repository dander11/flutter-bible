import 'package:bible_bloc/Blocs/navigation_bloc.dart';
import 'package:bible_bloc/InheritedBlocs.dart';
import 'package:bible_bloc/Views/BookDrawer/BookDrawer.dart';
import 'package:bible_bloc/Views/SearchPage/BibleSearchDelegate.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BibleBottomNavigationBar extends StatelessWidget {
  BibleBottomNavigationBar({
    Key key,
    BuildContext context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppPage>(
        stream: InheritedBlocs.of(context).navigationBloc.currentPage,
        initialData: AppPage.readerPage,
        builder: (context, snapshot) {
          int lastPage = snapshot.data.index;
          return Theme(
            data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
              canvasColor: Theme.of(context).primaryColor,
            ),
            child: BottomNavigationBar(
              fixedColor: Colors.white,
              currentIndex: snapshot.data.index,
              onTap: (index) {
                switch (index) {
                  case 0:
                    if (lastPage == index) {
                      showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(child: BooksList());
                          });
                    } else {
                      InheritedBlocs.of(context)
                          .navigationBloc
                          .nextPage
                          .add(AppPage.readerPage);
                    }

                    break;
                  case 1:
                    InheritedBlocs.of(context)
                        .navigationBloc
                        .nextPage
                        .add(AppPage.notesPage);
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
                /* BottomNavigationBarItem(
                title: Text("Search"),
                icon: Icon(Icons.search),
              ), */
              ],
            ),
          );
        });
  }
}
