import 'package:bible_bloc/Feature/Reader/bloc/reader_event.dart';
import 'package:bible_bloc/Foundation/Models/ChapterReference.dart';
import 'package:bloc/src/bloc.dart';

import 'package:bible_bloc/Feature/Reader/bloc/reader_state.dart';

import 'dart:async';

import '../../../Foundation/Models/CrossReferenceElements/VerseReferenceElement.dart';
import '../../../Foundation/Provider/IBibleProvider.dart';
import 'reader_bloc.dart';

class VerseReferenceBloc extends ReaderBloc {
  VerseReferenceBloc(IBibleProvider importer) : super(importer) {
    on<GoToVerseReferenceFromNumbers>(_goToVerseFromReferenceNumbers);
  }

  FutureOr<void> _goToVerseFromReferenceNumbers(
      GoToVerseReferenceFromNumbers event, Emitter<ReaderState> emit) async {
    emit(ReaderLoading());
    var referenceElement = event.referenceElement;
    var bookNumber = referenceElement.startingVerseId.substring(0, 2);
    var chapterNumber = referenceElement.startingVerseId.substring(2, 5);
    var verseNumber = referenceElement.startingVerseId.substring(5);
    var refChapter = await importer.getChapterByBookNumber(
        int.parse(bookNumber), int.parse(chapterNumber));
    this.add(
      ReaderGoToChapter(
        ChapterReference(
          chapter: refChapter,
          verseNumber: int.parse(verseNumber),
        ),
      ),
    );
  }
}

class GoToVerseReferenceFromNumbers extends ReaderEvent {
  final VerseReferenceElement referenceElement;

  GoToVerseReferenceFromNumbers(this.referenceElement);
  @override
  List<Object> get props => [this.referenceElement];
}
