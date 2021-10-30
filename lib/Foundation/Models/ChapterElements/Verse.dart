import 'package:flutter/material.dart';

import '../Chapter.dart';
import 'IChapterElement.dart';

class Verse extends IChapterElement {
  int id;
  final String text;
  final int number;
  Chapter chapter;

  Verse({this.number, this.text, this.chapter}) : super(chapter: chapter);

  @override
  List<Text> toTextWidget(BuildContext context) {
    List<Text> span = [
      Text(''' ${this.number} ${this.text}''',
          style: TextStyle(fontWeight: FontWeight.bold)),
    ];
    for (var verseElement in this.elements) {
      span.addAll(verseElement.toTextWidget(context));
    }
    return span;
  }

  @override
  InlineSpan toTextSpanWidget(BuildContext context) {
    TextSpan span = TextSpan(children: [
      TextSpan(
        text: ''' ${this.number}.''',
        style: TextStyle(
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
