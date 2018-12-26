// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Book _$BookFromJson(Map<String, dynamic> json) {
  return Book(
      name: json['Name'] as String,
      chapters: (json['chapters'] as List)
          ?.map((e) =>
              e == null ? null : Chapter.fromJson(e as Map<String, dynamic>))
          ?.toList())
    ..id = json['Id'] as int;
}

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
      'Id': instance.id,
      'Name': instance.name,
      'chapters': instance.chapters
    };
