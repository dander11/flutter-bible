import 'package:flutter/material.dart';
import 'IChapterElement.dart';

class EndParagraph extends IChapterElement {
  EndParagraph() : super();

  @override
  List<Text> toTextWidget(BuildContext context) {
    return [
      Text(
        '''\n\r''',
        style: TextStyle(fontWeight: FontWeight.normal),
      ),
    ];
  }

  @override
  TextSpan toTextSpanWidget(BuildContext context) {
    return TextSpan(
      children: [
        TextSpan(
          text: '''\n\r''',
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
