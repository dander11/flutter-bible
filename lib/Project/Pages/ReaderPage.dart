import '../../Foundation/Views/LoadingColumn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Feature/Navigation/navigation_feature.dart';
import '../../Feature/Reader/bloc/reader_bloc.dart';
import '../../Feature/Reader/bloc/reader_state.dart';
import '../../Feature/Reader/reader_feature.dart';
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
      body: BlocBuilder<ReaderBloc, ReaderState>(builder: (context, state) {
              if (state is ReaderLoaded) {
                var chapterReference = state.currentChapterReference;

                 return CustomScrollView(
                    controller: controller,
                    slivers: <Widget>[
                      BibleReaderAppBar(
                          title:
                              "${chapterReference.chapter.book.name} ${chapterReference.chapter.number}"),
                      SliverToBoxAdapter(
                        child: Reader(
                          nextChapter: state.nextChapter,
                          previousChapter: state.previousChapter,
                          chapterReference: state.currentChapterReference,
                          controller: controller,
                        ),
                      ),
                    ],
                  );
                
              }
              else{
                return  CustomScrollView(
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
            }),
     
      bottomNavigationBar: BibleBottomNavigationBar(context: context),
    );
  }
}
