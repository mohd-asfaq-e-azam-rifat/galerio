// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Album _$AlbumFromJson(Map<String, dynamic> json) => Album()
  ..id = json['id'] as String?
  ..name = json['name'] as String?
  ..isNewestOrder = json['is_newest_order'] as bool?
  ..count = (json['count'] as num?)?.toInt();

Map<String, dynamic> _$AlbumToJson(Album instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'is_newest_order': instance.isNewestOrder,
      'count': instance.count,
    };
