import 'package:bible_bloc/Models/ChapterElements/IChapterElement.dart';
import 'package:flutter/material.dart';

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
          text: this.text + "\n\r\n\r",
          style: Theme.of(context).textTheme.display1.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 19.0,
              ),
        ),
      ],
    );
    return span;
  }
}
