import 'package:bible_bloc/Models/Chapter.dart';

class ChapterReference {
  final Chapter chapter;
  final int verseNumber;

  ChapterReference({this.chapter, this.verseNumber = 1});
}
