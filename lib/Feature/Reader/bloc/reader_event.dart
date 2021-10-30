
import 'package:equatable/equatable.dart';

import '../../../Foundation/Models/ChapterReference.dart';
import '../../../Foundation/Models/CrossReferenceElements/VerseReferenceElement.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class ReaderEvent extends Equatable {}

class ReaderGoToChapter extends ReaderEvent {
  final ChapterReference reference;

  ReaderGoToChapter(this.reference);
  @override
  List<Object> get props =>[this.reference];
}

class ReaderGoToNextChapter extends ReaderEvent {
  @override
  List<Object> get props =>[];
}

class ReaderGoToPreviousChapter extends ReaderEvent {
  @override
  List<Object> get props =>[];
}

class ReaderGoToVerse extends ReaderEvent {
  final VerseReferenceElement referenceElement;

  ReaderGoToVerse(this.referenceElement);
  @override
  List<Object> get props =>[this.referenceElement];
}