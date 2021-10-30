import 'package:flutter/material.dart';

import 'CrossReferenceElements/ICrossReferenceElement.dart';

class CrossReference {
  String letter;
  String id;
  List<ICrossReferenceElement> elements;

  CrossReference({this.letter, this.id, this.elements});

  InlineSpan toInlineSpan(BuildContext context) {
    var span = TextSpan(children: []);
    for (var element in this.elements) {
      span.children.add(element.toInlineSpan(context));
    }
    return span;
  }
}
