import 'package:bible_bloc/Views/AppBar/BibleBottomNavigationBar.dart';
import 'package:bible_bloc/Views/AppBar/BibleTopAppBar.dart';
import 'package:bible_bloc/Views/Reader/Reader.dart';
import 'package:flutter/material.dart';

class ReaderPage extends StatelessWidget {
  const ReaderPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          BibleReaderAppBar(),
          SliverToBoxAdapter(child: Reader()),
        ],
      ),
      bottomNavigationBar: new BibleBottomNavigationBar(context: context),
    );
  }
}
