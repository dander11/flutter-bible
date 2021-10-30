import '../../../Feature/InheritedBlocs.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'IChapterElement.dart';

class CrossReferenceElement extends IChapterElement {
  final String letter;
  final String referenceId;
  CrossReferenceElement({this.letter, this.referenceId}) : super();

  @override
  List<Text> toTextWidget(BuildContext context) {
    return [
      Text(
        ''' ${this.letter.trim()} ''',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ];
  }

  @override
  InlineSpan toTextSpanWidget(BuildContext context) {
    //var reg = RegExp("\s[.!?\\-]", caseSensitive: false);
    //var text = this.text.replaceAllMapped(reg, (Match m) => "${m[1]}");
    if (this.letter == null || this.letter.isEmpty) {
      return TextSpan(text: "");
    }
    var span = TextSpan(
      children: [
        WidgetSpan(
            child: InkWell(
              onTap: () {
                HapticFeedback.vibrate();
                InheritedBlocs.of(context)
                    .openChapterReference(context, referenceId);
              },
              child: Text(
                '''${this.letter}''',
                style: Theme.of(context).textTheme.caption.copyWith(
                      color: Colors.blue,
                    ),
              ),
            ),
            alignment: PlaceholderAlignment.top)
      ],
    );

    return span;
  }
}
