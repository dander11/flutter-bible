import 'Chapter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Book.g.dart';

@JsonSerializable()
class Book {
  final String name;
  @JsonKey(ignore: true)
  final List<Chapter> chapters;

  Book({this.name, this.chapters});

  Chapter getChapter(int chapterNumber) {
    if (chapterNumber < 0 || chapterNumber > chapters.length) {
      throw new ArgumentError("This chapter doesn't exist in this book");
    }

    return chapters[chapterNumber - 1];
  }

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson` constructor.
  /// The constructor is named after the source class, in this case User.
  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$BookToJson(this);
}
