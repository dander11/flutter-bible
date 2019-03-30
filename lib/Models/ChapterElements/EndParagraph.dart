import 'package:bible_bloc/Models/ChapterElements/IChapterElement.dart';
import 'package:flutter/material.dart';

class EndParagraph extends IChapterElement {
  EndParagraph() : super();

  @override
  List<Text> toTextWidget(BuildContext context) {
    return [
      Text(
        '''\n\r''',
        style: new TextStyle(fontWeight: FontWeight.normal),
      ),
    ];
  }

  @override
  TextSpan toTextSpanWidget(BuildContext context) {
    return TextSpan(
      children: [
        TextSpan(
          text: '''\n\r\n\r   ''',
          style: new TextStyle(fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
