import 'package:bible_bloc/Models/ChapterElements/IChapterElement.dart';
import 'package:flutter/material.dart';

class BeginParagraph extends IChapterElement {
  BeginParagraph() : super();

  @override
  List<Text> toTextWidget(BuildContext context) {
    return [
      Text(
        '''\t''',
        style: TextStyle(fontWeight: FontWeight.normal),
      ),
    ];
  }

  @override
  TextSpan toTextSpanWidget(BuildContext context) {
    return TextSpan(
      children: [
        TextSpan(
          text: '''   ''',
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
