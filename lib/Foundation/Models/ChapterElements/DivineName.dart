import 'package:flutter/material.dart';
import 'IChapterElement.dart';

class DivineName extends IChapterElement {
  final String text;
  DivineName({this.text}) : super();

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
  TextSpan toTextSpanWidget(BuildContext context) {
    //var reg = RegExp("\s[.!?\\-]", caseSensitive: false);
    //var text = this.text.replaceAllMapped(reg, (Match m) => "${m[1]}");

    var span = TextSpan(
      children: [
        TextSpan(
          text: '''${this.text}''',
          style: Theme.of(context).textTheme.body2,
        )
      ],
    );

    return span;
  }
}
