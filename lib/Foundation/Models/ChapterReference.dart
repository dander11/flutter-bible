import 'Book.dart';
import 'Chapter.dart';
import 'package:flutter/material.dart';

class ChapterReference {
  Chapter chapter;
  int verseNumber;

  ChapterReference({@required this.chapter, this.verseNumber = 1});

  ChapterReference.fromJson(Map<String, dynamic> json) {
    Book book = Book(name: json['book']);
    Chapter aChapter = Chapter(
      book: book,
      number: json[chapter],
    );
    ChapterReference(chapter: aChapter, verseNumber: json['verse']);
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
