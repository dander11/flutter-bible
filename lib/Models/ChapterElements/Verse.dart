import 'package:bible_bloc/InheritedBlocs.dart';
import 'package:bible_bloc/Models/Chapter.dart';
import 'package:bible_bloc/Models/ChapterElements/IChapterElement.dart';

import 'package:flutter/material.dart';

class Verse extends IChapterElement {
  int id;
  final String text;
  final int number;
  Chapter chapter;

  Verse({this.number, this.text}) : super();

  @override
  List<Text> toTextWidget(BuildContext context) {
    List<Text> span = [
      Text(''' ${this.number} ''',
          style: new TextStyle(fontWeight: FontWeight.bold)),
    ];
    for (var verseElement in this.elements) {
      span.addAll(verseElement.toTextWidget(context));
    }
    return span;
  }

  @override
  TextSpan toTextSpanWidget(BuildContext context) {
    TextSpan span = TextSpan(children: [
      TextSpan(
        text: ''' ${this.number}.''',
        style: new TextStyle(
          fontWeight: FontWeight.w400,
        ),
      ),
    ]);

    for (var verseElement in this.elements) {
      span.children.add(verseElement.toTextSpanWidget(context));
    }
    return span;
  }
}
