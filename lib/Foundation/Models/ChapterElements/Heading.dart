import 'package:flutter/material.dart';
import 'IChapterElement.dart';

class Heading extends IChapterElement {
  final String text;

  Heading({this.text}) : super();

  @override
  List<Text> toTextWidget(BuildContext context) {
    return [
      Text(
        this.text + '''\n''',
        style: Theme.of(context).textTheme.subtitle,
      ),
    ];
  }

  @override
  TextSpan toTextSpanWidget(BuildContext context) {
    var span = TextSpan(
      children: [
        TextSpan(
          text: "\n\r" + this.text + "\n\r",
          style: Theme.of(context).textTheme.display1.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 18.0,
              ),
        ),
      ],
    );
    return span;
  }
}
