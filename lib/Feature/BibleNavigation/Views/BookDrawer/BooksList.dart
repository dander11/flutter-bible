import '../../../InheritedBlocs.dart';
import 'package:flutter/material.dart';

import 'BookPanel.dart';

class BooksList extends StatelessWidget {
  const BooksList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder(
          stream: InheritedBlocs.of(context).bibleBloc.books,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Expanded(
                flex: 1,
                child: ListView.builder(
                  key: PageStorageKey("booksList"),
                  itemBuilder: (BuildContext context, int index) => BookPanel(
                        book: snapshot.data[index],
                      ),
                  itemCount: snapshot.data.length,
                ),
              );
            } else {
              return Container();
            }
          }, initialData: null,
        ),
      ],
    );
  }
}
