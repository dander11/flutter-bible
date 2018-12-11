// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Chapter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chapter _$ChapterFromJson(Map<String, dynamic> json) {
  return Chapter(
      json['number'] as int,
      (json['verses'] as List)
          ?.map((e) =>
              e == null ? null : Verse.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['book'] == null
          ? null
          : Book.fromJson(json['book'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ChapterToJson(Chapter instance) => <String, dynamic>{
      'verses': instance.verses,
      'book': instance.book,
      'number': instance.number
    };
