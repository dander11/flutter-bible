import 'package:bible_bloc/InheritedBlocs.dart';
import 'package:bible_bloc/Views/BookDrawer/BookPanel.dart';
import 'package:flutter/material.dart';

class BookDrawer extends StatelessWidget {
  BookDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      semanticLabel: "Books",
      child: StreamBuilder(
        stream: InheritedBlocs.of(context).bibleBloc.books,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) => BookPanel(
                        book: snapshot.data[index],
                      ),
                  itemCount: snapshot.data.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
