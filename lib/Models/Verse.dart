import 'package:bible_bloc/Models/Chapter.dart';
import 'package:bible_bloc/Models/IChapterElement.dart';

class Verse extends IChapterElement {
  int id;
  final String text;
  final int number;
  Chapter chapter;

  Verse({this.number, this.text});
}
