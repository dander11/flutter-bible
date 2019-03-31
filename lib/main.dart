import 'dart:convert';
import 'package:bible_bloc/Blocs/navigation_bloc.dart';
import 'package:bible_bloc/Blocs/notes_bloc.dart';
import 'package:bible_bloc/Blocs/settings_bloc.dart';
import 'package:bible_bloc/Views/AppBar/BibleBottomNavigationBar.dart';
import 'package:bible_bloc/Blocs/bible_bloc.dart';
import 'package:bible_bloc/Designs/DarkDesign.dart';
import 'package:bible_bloc/InheritedBlocs.dart';
import 'package:bible_bloc/Views/Notes/NoteTaker.dart';
import 'package:bible_bloc/Views/Notes/NotesIndex.dart';
import 'package:bible_bloc/Views/Reader/ReaderPage.dart';
import 'package:flutter/material.dart';
import 'package:notus/notus.dart';
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
      notesBloc: NotesBloc(),
      navigationBloc: NavigationBloc(),
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
    return StreamBuilder<AppPage>(
        stream: InheritedBlocs.of(context).navigationBloc.currentPage,
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case AppPage.readerPage:
              return Scaffold(
                body: ReaderPage(),
                bottomNavigationBar:
                    new BibleBottomNavigationBar(context: context),
              );
              break;

            case AppPage.notesPage:
              return Scaffold(
                body: NotesIndex(),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    showCreateNoteDialog();
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
                bottomNavigationBar:
                    new BibleBottomNavigationBar(context: context),
              );
              break;
            default:
              return new ReaderPage();
              break;
          }
        });
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

  Future showCreateNoteDialog() async {
    final _formKey = GlobalKey<FormState>();
    var text = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _controller = TextEditingController();
        return SimpleDialog(
          children: <Widget>[
            Form(
              key: _formKey,
              autovalidate: false,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _controller,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Title",
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                      },
                    ),
                    RaisedButton(
                      onPressed: () {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState.validate()) {
                          Navigator.pop(context, _controller.text);
                        }
                      },
                      child: Text('Submit'),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
    if (text != null) {
      var id =
          await InheritedBlocs.of(context).notesBloc.highestNoteId.first ?? 0;
      id++;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return NotePage(
              note: Note(
                id: id,
                title: text,
                lastUpdated: DateTime.now(),
                doc: NotusDocument(),
              ),
            );
          },
        ),
      );
    }
  }
}
