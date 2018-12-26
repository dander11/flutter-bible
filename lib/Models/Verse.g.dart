// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Verse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Verse _$VerseFromJson(Map<String, dynamic> json) {
  return Verse(number: json['Number'] as int, text: json['Text'] as String)
    ..id = json['Id'] as int
    ..chapter = json['chapter'] == null
        ? null
        : Chapter.fromJson(json['chapter'] as Map<String, dynamic>);
}

Map<String, dynamic> _$VerseToJson(Verse instance) => <String, dynamic>{
      'Id': instance.id,
      'Text': instance.text,
      'Number': instance.number,
      'chapter': instance.chapter
    };
