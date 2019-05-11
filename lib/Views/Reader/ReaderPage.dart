import 'package:bible_bloc/InheritedBlocs.dart';
import 'package:bible_bloc/Models/ChapterReference.dart';
import 'package:bible_bloc/Views/AppBar/BibleBottomNavigationBar.dart';
import 'package:bible_bloc/Views/AppBar/BibleTopAppBar.dart';
import 'package:bible_bloc/Views/LoadingColumn.dart';
import 'package:bible_bloc/Views/Reader/Reader.dart';
import 'package:flutter/material.dart';

class ReaderPage extends StatefulWidget {
  const ReaderPage({
    Key key,
  }) : super(key: key);

  @override
  _ReaderPageState createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  ScrollController controller = ScrollController();
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
      body: StreamBuilder(
        stream: InheritedBlocs.of(context).bibleBloc.previousChapter,
        builder: (_, prevChapter) => StreamBuilder(
              stream: InheritedBlocs.of(context).bibleBloc.nextChapter,
              builder: (_, nextChapter) {
                return StreamBuilder<ChapterReference>(
                    stream:
                        InheritedBlocs.of(context).bibleBloc.chapterReference,
                    builder: (context,
                        AsyncSnapshot<ChapterReference> chapterReference) {
                      if (chapterReference.hasData &&
                          prevChapter.hasData &&
                          nextChapter.hasData) {
                        return CustomScrollView(
                          controller: controller,
                          slivers: <Widget>[
                            BibleReaderAppBar(
                                title:
                                    "${chapterReference.data.chapter.book.name} ${chapterReference.data.chapter.number}"),
                            SliverToBoxAdapter(
                              child: Reader(
                                nextChapter: nextChapter.data,
                                previousChapter: prevChapter.data,
                                chapterReference: chapterReference.data,
                                controller: controller,
                                //scrollToVerseMethod: _scrollToVerse,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return CustomScrollView(
                          controller: controller,
                          slivers: <Widget>[
                            BibleReaderAppBar(
                              title: "Loading...",
                            ),
                            SliverToBoxAdapter(
                              child: LoadingColumn(),
                            ),
                          ],
                        );
                      }
                    });
              },
            ),
      ),
      bottomNavigationBar: BibleBottomNavigationBar(context: context),
    );
  }
}
