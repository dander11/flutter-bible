// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Chapter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chapter _$ChapterFromJson(Map<String, dynamic> json) {
  return Chapter(
      number: json['Number'] as int,
      verses: (json['verses'] as List)
          ?.map((e) =>
              e == null ? null : Verse.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      book: json['book'] == null
          ? null
          : Book.fromJson(json['book'] as Map<String, dynamic>))
    ..id = json['Id'] as int;
}

Map<String, dynamic> _$ChapterToJson(Chapter instance) => <String, dynamic>{
      'Id': instance.id,
      'verses': instance.verses,
      'book': instance.book,
      'Number': instance.number
    };
