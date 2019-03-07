import 'dart:convert';
import 'package:bible_bloc/Blocs/settings_bloc.dart';
import 'package:bible_bloc/Views/SearchPage/BibleSearchDelegate.dart';
import 'package:bible_bloc/Views/Settings/SettingPopupMenu.dart';
import 'package:bible_bloc/Blocs/bible_bloc.dart';
import 'package:bible_bloc/Designs/DarkDesign.dart';
import 'package:bible_bloc/InheritedBlocs.dart';
import 'package:bible_bloc/Models/Book.dart';
import 'package:bible_bloc/Models/Chapter.dart';
import 'package:bible_bloc/Views/BookDrawer/BookDrawer.dart';
import 'package:bible_bloc/Views/VerseViewer/DismissableVerseViewer.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:global_configuration/global_configuration.dart';

void main() async {
  await GlobalConfiguration().loadFromAsset("app_settings");
  final bibleBloc = BibleBloc();
  runApp(MyApp(
    bibleBloc: bibleBloc,
    settingsBloc: SettingsBloc(),
  ));
}

class MyApp extends StatelessWidget {
  final bibleBloc;
  final settingsBloc;

  MyApp({this.bibleBloc, this.settingsBloc});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return InheritedBlocs(
      bibleBloc: bibleBloc,
      settingsBloc: settingsBloc,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: Designs.darkTheme,
        home: MyHomePage(
          title: 'Flutter Demo Home Page',
          bibleBloc: bibleBloc,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.bibleBloc}) : super(key: key);
  final String title;
  final bibleBloc;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String membershipKey = 'david.anderson.bibleapp';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          new BibleAppBar(),
          SliverToBoxAdapter(
            child: StreamBuilder(
              stream: InheritedBlocs.of(context).bibleBloc.chapter,
              //initialData: Chapter(1, []),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  //saveCurrentBookAndChapter();
                  return StreamBuilder<bool>(
                    stream: InheritedBlocs.of(context)
                        .settingsBloc
                        .showVerseNumbers,
                    initialData: false,
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> setting) {
                      if (setting.hasData) {
                        return Verses(
                          addBackgrounds: true,
                          book: snapshot.data.book,
                          chapter: snapshot.data,
                          swipeAction: swipeVersesAway,
                          showVerseNumbers: setting.data,
                        );
                      } else {
                        return Verses(
                          addBackgrounds: true,
                          book: snapshot.data.book,
                          chapter: snapshot.data,
                          swipeAction: swipeVersesAway,
                          showVerseNumbers: true,
                        );
                      }
                    },
                  );
                } else {
                  //readCurrentBookAndChapter();
                  return new LoadingColumn();
                }
              },
            ),
          ),
        ],
      ),
      drawer: BookDrawer(),
    );
  }

  void saveCurrentBookAndChapter() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var currentChapter =
        await InheritedBlocs.of(context).bibleBloc.chapter.first;
    sp.setString(membershipKey, json.encode(currentChapter));
  }

  void readCurrentBookAndChapter() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();

      /* var loadedChapter =
          Chapter.fromJson(json.decode(sp.getString(membershipKey)));
      var books = await InheritedBlocs.of(context).bibleBloc.books.first;
      var currentChapter = books
          .firstWhere((book) => book.name == loadedChapter.book.name)
          .chapters
          .firstWhere((chapter) => chapter.number == loadedChapter.number);
      InheritedBlocs.of(context).bibleBloc.currentChapter.add(currentChapter); */
    } catch (e) {
      //return new AppState();
    }
  }

  swipeVersesAway(DismissDirection swipeDetails) async {
    Chapter currentChapter =
        await InheritedBlocs.of(context).bibleBloc.chapter.first;
    var books = await InheritedBlocs.of(context).bibleBloc.books.first;
    if (swipeDetails == DismissDirection.endToStart) {
      goToNextChapter(books, currentChapter);
    } else {
      goToPreviousChapter(books, currentChapter);
    }
    // saveCurrentBookAndChapter();
  }

  void goToPreviousChapter(
      UnmodifiableListView<Book> books, Chapter currentChapter) {
    if (books.first == currentChapter.book && currentChapter.number == 1) {
      var prevBook = books.last;
      InheritedBlocs.of(context)
          .bibleBloc
          .currentChapter
          .add(prevBook.chapters.last);
    } else if (1 == currentChapter.number) {
      var prevBook = books[books.indexOf(currentChapter.book) - 1];
      InheritedBlocs.of(context)
          .bibleBloc
          .currentChapter
          .add(prevBook.chapters.last);
    } else {
      Chapter prevChapter = currentChapter.book
          .chapters[currentChapter.book.chapters.indexOf(currentChapter) - 1];
      InheritedBlocs.of(context).bibleBloc.currentChapter.add(prevChapter);
    }
  }

  void goToNextChapter(
      UnmodifiableListView<Book> books, Chapter currentChapter) {
    if (books.last == currentChapter.book &&
        currentChapter.number == currentChapter.book.chapters.length) {
      var nextBook = books.first;
      InheritedBlocs.of(context)
          .bibleBloc
          .currentChapter
          .add(nextBook.chapters.first);
    } else if (currentChapter.book.chapters.length == currentChapter.number) {
      var nextBook = books[books.indexOf(currentChapter.book) + 1];
      InheritedBlocs.of(context)
          .bibleBloc
          .currentChapter
          .add(nextBook.chapters.first);
    } else {
      Chapter nextChapter = currentChapter.book
          .chapters[currentChapter.book.chapters.indexOf(currentChapter) + 1];
      InheritedBlocs.of(context).bibleBloc.currentChapter.add(nextChapter);
    }
  }
}

class BibleAppBar extends StatelessWidget {
  const BibleAppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      title: StreamBuilder<Chapter>(
        stream: InheritedBlocs.of(context).bibleBloc.chapter,
        builder: (BuildContext context, AsyncSnapshot<Chapter> snapshot) {
          if (snapshot.hasData) {
            return Text("${snapshot.data.book.name} ${snapshot.data.number}");
          } else {
            return Text("");
          }
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: BibleSearchDelegate(),
            );
          },
        ),
        SettingsPopupMenu(),
      ],
    );
  }
}

class LoadingColumn extends StatelessWidget {
  const LoadingColumn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
