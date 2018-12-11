// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Verse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Verse _$VerseFromJson(Map<String, dynamic> json) {
  return Verse(number: json['number'] as int, text: json['text'] as String);
}

Map<String, dynamic> _$VerseToJson(Verse instance) =>
    <String, dynamic>{'text': instance.text, 'number': instance.number};
