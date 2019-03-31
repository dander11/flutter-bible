import 'package:bible_bloc/Models/Chapter.dart';
import 'package:flutter/material.dart';

abstract class IChapterElement {
  int id;
  Chapter chapter;
  List<IChapterElement> elements;

  IChapterElement({this.chapter, this.id}) {
    elements = new List<IChapterElement>();
  }

  List<Text> toTextWidget(BuildContext context);

  TextSpan toTextSpanWidget(BuildContext context);
}
