import 'IChapterElement.dart';
import 'package:flutter/material.dart';

class WordsOfChrist extends IChapterElement {
  final String text;
  WordsOfChrist({this.text}) : super();

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
      children: [],
    );
    if (text.length == 1 && text.contains(RegExp("[.!?\\-]"))) {
      span.children.add(TextSpan(
        text: '''${this.text.trim()}''',
        style: Theme.of(context).textTheme.body2,
      ));
    } else {
      span.children.add(TextSpan(
        text: ''' ${this.text.trim()}''',
        style: Theme.of(context).textTheme.body2,
      ));
    }

    return span;
  }
}
