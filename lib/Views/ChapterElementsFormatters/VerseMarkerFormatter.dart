import 'package:bible_bloc/Models/IChapterElement.dart';
import 'package:bible_bloc/Models/Verse.dart';
import 'package:bible_bloc/Views/ChapterElementsFormatters/IChapterElementFormatter.dart';
import 'package:flutter/material.dart';

class VerseMarkerFormatter extends IChapterElementFormatter {
  @override
  TextSpan format(IChapterElement element) {
    Verse verse = element as Verse;
    var number = new TextSpan(
        text: ' ' + verse.number.toString() + ' ',
        style: new TextStyle(fontWeight: FontWeight.bold),
      );
    return number;
  }
  
}