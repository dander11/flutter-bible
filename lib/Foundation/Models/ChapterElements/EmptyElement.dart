import 'package:flutter/material.dart';
import 'IChapterElement.dart';

class EmptyElement extends IChapterElement {
  @override
  List<Text> toTextWidget(BuildContext context) {
    if (this.elements.length > 0) {
      var span = List<Text>();
      for (var verseElement in this.elements) {
        span.addAll(verseElement.toTextWidget(context));
      }
      return span;
    } else {
      return [
        Text(""),
      ];
    }
  }

  @override
  TextSpan toTextSpanWidget(BuildContext context) {
    var span = TextSpan(children: []);
    if (this.elements.length > 0) {
      for (var verseElement in this.elements) {
        span.children.add(verseElement.toTextSpanWidget(context));
      }
      return span;
    } else {
      span.children.add(
        TextSpan(text: ""),
      );
      return span;
    }
  }
}
