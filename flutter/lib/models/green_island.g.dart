// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'green_island.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GreenIsland _$GreenIslandFromJson(Map<String, dynamic> json) => GreenIsland()
  ..id = json['id'] as int?
  ..title = json['title'] as String?
  ..description = json['description'] as String?
  ..longitude = (json['longitude'] as num).toDouble()
  ..latitude = (json['latitude'] as num).toDouble()
  ..active = json['active'] as bool?
  ..municipality = json['municipality'] == null
      ? null
      : Municipality.fromJson(json['municipality'] as Map<String, dynamic>)
  ..images = (json['images'] as List<dynamic>?)
      ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
      .toList()
  ..firstImage = json['firstImage'] == null
      ? null
      : Image.fromJson(json['firstImage'] as Map<String, dynamic>);

Map<String, dynamic> _$GreenIslandToJson(GreenIsland instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'active': instance.active,
      'municipality': instance.municipality,
      'images': instance.images,
      'firstImage': instance.firstImage,
    };

Municipality _$MunicipalityFromJson(Map<String, dynamic> json) => Municipality()
  ..id = json['id'] as int?
  ..title = json['title'] as String?
  ..description = json['description'] as String?;

Map<String, dynamic> _$MunicipalityToJson(Municipality instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
    };

Image _$ImageFromJson(Map<String, dynamic> json) => Image()
  ..id = json['id'] as int?
  ..fileName = json['fileName'] as String?
  ..filePath = json['filePath'] as String?;

Map<String, dynamic> _$ImageToJson(Image instance) => <String, dynamic>{
      'id': instance.id,
      'fileName': instance.fileName,
      'filePath': instance.filePath,
    };
