import 'package:bible_bloc/Models/ChapterElements/IChapterElement.dart';
import 'package:flutter/material.dart';

class Subheading extends IChapterElement {
  final String text;

  Subheading({this.text}) : super();

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
          text: '''${this.text}\n\r''',
          style: Theme.of(context).textTheme.body2.copyWith(
                fontStyle: FontStyle.italic,
              ),
        ),
      ],
    );
    return span;
  }
}
