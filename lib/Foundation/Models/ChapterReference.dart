import 'package:flutter/material.dart';

import 'Book.dart';
import 'Chapter.dart';

class ChapterReference {
  Chapter chapter;
  int verseNumber;

  ChapterReference({@required this.chapter, this.verseNumber = 1});

  factory ChapterReference.fromJson(Map<String, dynamic> json) {
    Book book = Book(name: json['book']);
    Chapter aChapter = Chapter(
      book: book,
      number: json["chapter"],
    );
   return ChapterReference(chapter: aChapter, verseNumber: json['verse']);
  }

  Map<String, dynamic> toJson() => {
        'chapter': chapter.number,
        'verse': verseNumber,
        'book': chapter.book.name
      };

  @override
  String toString() {
    return "${chapter.book.name} ${chapter.number}: $verseNumber";
  }

  @override
  int get hashCode {
    return ("${chapter.book.name} + ${chapter.number} + $verseNumber").hashCode;
  }

  operator ==(Object other) => hashCode == other.hashCode;
}
