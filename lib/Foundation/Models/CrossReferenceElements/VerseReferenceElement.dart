import 'package:bible_bloc/Feature/InheritedBlocs.dart';
import 'package:bible_bloc/Foundation/Models/CrossReferenceElements/ICrossReferenceElement.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/painting/inline_span.dart';

class VerseReferenceElement extends ICrossReferenceElement {
  String startingVerseId;
  String endingVerseId;

  VerseReferenceElement({text, this.startingVerseId, this.endingVerseId})
      : super(text: text);

  @override
  InlineSpan toInlineSpan(BuildContext context) {
    // TODO: implement toInlineSpan
    var span = TextSpan(
      children: [
        WidgetSpan(
            child: InkWell(
              onTap: () {
                HapticFeedback.vibrate();
                InheritedBlocs.of(context)
                    .openVerseReferenceInSheet(context, this);
              },
              child: Text(
                '''${this.text}''',
                style: Theme.of(context).textTheme.body2.copyWith(
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
