import 'package:bible_bloc/Models/ChapterElements/IChapterElement.dart';
import 'package:flutter/material.dart';

abstract class IChapterElementFormatter {
  TextSpan format(IChapterElement element);
}
