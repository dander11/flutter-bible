import 'package:bible_bloc/Blocs/navigation_bloc.dart';
import 'package:bible_bloc/Blocs/notes_bloc.dart';
import 'package:bible_bloc/Blocs/search_bloc.dart';
import 'package:bible_bloc/Blocs/settings_bloc.dart';
import 'package:bible_bloc/Blocs/bible_bloc.dart';
import 'package:bible_bloc/Designs/DarkDesign.dart';
import 'package:bible_bloc/InheritedBlocs.dart';
import 'package:bible_bloc/Providers/MultiPartXmlBibleProvider.dart';
import 'package:bible_bloc/Providers/XmlBibleProvider.dart';
import 'package:bible_bloc/Views/Notes/NotesPage.dart';
import 'package:bible_bloc/Views/Reader/ReaderPage.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

void main() async {
  await GlobalConfiguration().loadFromAsset("app_settings");
  final bibleBloc = BibleBloc(MultiPartXmlBibleProvider());
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
      searchBloc: SearchBloc(XmlBibleProvider()),
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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppPage>(
        stream: InheritedBlocs.of(context).navigationBloc.currentPage,
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case AppPage.readerPage:
              return ReaderPage();
              break;

            case AppPage.notesPage:
              return NotesPage();
              break;

            case AppPage.historyPage:
              return ReaderPage();
              break;
            default:
              return ReaderPage();
              break;
          }
        });
  }
}
