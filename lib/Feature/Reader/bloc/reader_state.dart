
import 'package:equatable/equatable.dart';

import '../../../Foundation/Models/Chapter.dart';
import '../../../Foundation/Models/ChapterReference.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class ReaderState extends Equatable {}

class ReaderInitial extends ReaderState {
  @override
  List<Object> get props => [];
}


class ReaderLoading extends ReaderState {
  @override
  List<Object> get props =>[];
}

class ReaderLoaded extends ReaderState {
  final ChapterReference currentChapterReference;
  final Chapter nextChapter;
  final Chapter previousChapter;

  ReaderLoaded(this.currentChapterReference, this.nextChapter, this.previousChapter);

  @override
  List<Object> get props => [this.currentChapterReference,this.nextChapter,this.previousChapter];
}
