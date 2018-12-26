import 'package:bible_bloc/Models/Chapter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Verse.g.dart';

@JsonSerializable()
class Verse {
  @JsonKey(name: 'Id')
  int id;
  @JsonKey(name: 'Text')
  final String text;
  @JsonKey(name: 'Number')
  final int number;
  @JsonKey(required: false)
  Chapter chapter;

  Verse({this.number, this.text});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson` constructor.
  /// The constructor is named after the source class, in this case User.
  factory Verse.fromJson(Map<String, dynamic> json) => _$VerseFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$VerseToJson(this);
}
