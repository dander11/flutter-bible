import 'package:bible_bloc/Models/ChapterElements/IChapterElement.dart';
import 'package:bible_bloc/Models/ChapterElements/Verse.dart';
import 'package:bible_bloc/Views/ChapterElementsFormatters/IChapterElementFormatter.dart';
import 'package:flutter/material.dart';

class VerseFormatter extends IChapterElementFormatter {
  @override
  TextSpan format(IChapterElement element) {
    Verse verse = element as Verse;
    var span = TextSpan(
      text: verse.text + ' ',
      style: new TextStyle(fontWeight: FontWeight.normal),
    );
    return span;
  }
}
