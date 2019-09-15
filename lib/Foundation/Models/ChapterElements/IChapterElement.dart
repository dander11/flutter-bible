import '../Chapter.dart';
import 'package:flutter/material.dart';
import 'IChapterElement.dart';

abstract class IChapterElement {
  int id;
  Chapter chapter;
  List<IChapterElement> elements;

  IChapterElement({this.chapter, this.id}) {
    elements = List<IChapterElement>();
  }

  List<Text> toTextWidget(BuildContext context);

  TextSpan toTextSpanWidget(BuildContext context);
}
