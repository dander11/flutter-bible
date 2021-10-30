import 'Feature/Reader/bloc/reader_bloc.dart';
import 'Foundation/Provider/MultiPartXmlBibleProvider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Feature/InheritedBlocs.dart';
import 'Feature/Navigation/navigation_feature.dart';
import 'Feature/Notes/notes_feature.dart';
import 'Feature/Reader/reader_feature.dart';
import 'Feature/Search/search_feature.dart';
import 'Feature/Settings/settings_feature.dart';
import 'Foundation/Provider/ReferenceProvider.dart';
import 'Foundation/Search/XmlBibleProvider.dart';
import 'Project/Designs/DarkDesign.dart';
import 'Project/Pages/NotesPage.dart';
import 'Project/Pages/ReaderPage.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

import 'Project/Pages/HistoryPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("app_settings");
  final bibleBloc = BibleBloc(MultiPartXmlBibleProvider(), ReferenceProvider());
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
    return BlocProvider(
      create: (context) => ReaderBloc(MultiPartXmlBibleProvider()),
      child: InheritedBlocs(
        bibleBloc: bibleBloc,
        settingsBloc: settingsBloc,
        notesBloc: NotesBloc(),
        navigationBloc: NavigationBloc(),
        searchBloc: SearchBloc(XmlBibleProvider()),
        child: MaterialApp(
          theme: Designs.darkTheme,
          home: MyHomePage(
            bibleBloc: bibleBloc,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.bibleBloc}) : super(key: key);
  final bibleBloc;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppPage>(
      stream: InheritedBlocs.of(context).navigationBloc.currentPage,
      builder: (context, currentPageSnapshot) {
        switch (currentPageSnapshot.data) {
          case AppPage.readerPage:
            return ReaderPage();
            break;

          case AppPage.notesPage:
            return NotesPage();
            break;

          case AppPage.historyPage:
            return HistoryPage();
            break;
          default:
            return ReaderPage();
            break;
        }
      },
      initialData: null,
    );
  }
}
