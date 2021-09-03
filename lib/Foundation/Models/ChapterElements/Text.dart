import 'package:flutter/material.dart';
import 'IChapterElement.dart';

class ChapterText extends IChapterElement {
  final String text;
  ChapterText({this.text}) : super();

  @override
  List<Text> toTextWidget(BuildContext context) {
    return [
      Text(
        ''' ${this.text.trim()} ''',
        style: TextStyle(fontWeight: FontWeight.normal),
      ),
    ];
  }

  @override
  InlineSpan toTextSpanWidget(BuildContext context) {
    //var reg = RegExp("\s[.!?\\-]", caseSensitive: false);
    //var text = this.text.replaceAllMapped(reg, (Match m) => "${m[1]}");

    var span = TextSpan(
      children: [
        TextSpan(
          text: '''${this.text}''',
          style: Theme.of(context).textTheme.bodyText2,
        )
      ],
    );
    return span;
  }
}
