import 'package:bible_bloc/Models/Book.dart';
import 'package:json_annotation/json_annotation.dart';
import 'Verse.dart';

part 'Chapter.g.dart';

@JsonSerializable()
class Chapter {
  List<Verse> verses;
  Book book;
  int number;

  Chapter(this.number, this.verses, [this.book]);

  Verse getVerse(int verseNumber) {
    if (verseNumber < 0 || verseNumber > verses.length) {
      throw new ArgumentError("This verse doesn't exist in this chapter");
    }

    return verses[verseNumber - 1];
  }

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson` constructor.
  /// The constructor is named after the source class, in this case User.
  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ChapterToJson(this);
}
