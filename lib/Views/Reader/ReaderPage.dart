import 'package:bible_bloc/InheritedBlocs.dart';
import 'package:bible_bloc/Models/ChapterElements/IChapterElement.dart';
import 'package:bible_bloc/Models/ChapterElements/Verse.dart';
import 'package:bible_bloc/Models/ChapterReference.dart';
import 'package:bible_bloc/Views/AppBar/BibleBottomNavigationBar.dart';
import 'package:bible_bloc/Views/AppBar/BibleTopAppBar.dart';
import 'package:bible_bloc/Views/Reader/Reader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ReaderPage extends StatefulWidget {
  const ReaderPage({
    Key key,
  }) : super(key: key);

  @override
  _ReaderPageState createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  ScrollController controller = ScrollController();
  ChapterReference chapterReference;
  bool hasScrolled;

  @override
  void initState() {
    //controller.addListener(_scrollToVerse);
    hasScrolled = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<ChapterReference>(
          stream: InheritedBlocs.of(context).bibleBloc.chapterReference,
          builder: (context, AsyncSnapshot<ChapterReference> chapterReference) {
            if (chapterReference.hasData) {
              var scrollView = CustomScrollView(
                controller: controller,
                slivers: <Widget>[
                  BibleReaderAppBar(),
                  SliverToBoxAdapter(
                      child: Reader(
                    scrollToVerseMethod: _scrollToVerse,
                  )),
                ],
              );
              this.chapterReference = chapterReference.data;
              //_scrollToVerse();

              return scrollView;
            } else {
              return CustomScrollView(
                controller: controller,
                slivers: <Widget>[
                  BibleReaderAppBar(),
                  SliverToBoxAdapter(
                      child: Reader(
                    scrollToVerseMethod: _scrollToVerse,
                  )),
                ],
              );
            }
          }),
      bottomNavigationBar: new BibleBottomNavigationBar(context: context),
    );
  }

  double _getScrollOffset(int length, int verseNumber) {
    if (length > 0) {
      return verseNumber / length;
    } else {
      return 0;
    }
  }

  List<IChapterElement> _flattenList(List<IChapterElement> iterable) {
    return iterable
        .expand((IChapterElement e) =>
            e.elements != null && e.elements.length > 0 && !(e is Verse)
                ? _flattenList(e.elements)
                : [e])
        .toList();
  }

  Future<void> _scrollToVerse() async {
    while (!controller.hasClients) {}
    var scrollPosition = controller.position;
    if (scrollPosition.viewportDimension < scrollPosition.maxScrollExtent) {
      var verses =
          _flattenList(chapterReference.chapter.elements).whereType<Verse>();

      var scrollPercentage =
          _getScrollOffset(verses.length, chapterReference.verseNumber);
      var positon = controller.position.maxScrollExtent * scrollPercentage;
      controller.animateTo(
        positon,
        duration: Duration(
          milliseconds: 100,
        ),
        curve: Curves.bounceInOut,
      );
    }
  }
}
