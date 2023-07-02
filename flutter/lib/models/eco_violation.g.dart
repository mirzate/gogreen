// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eco_violation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ecoviolation _$EcoviolationFromJson(Map<String, dynamic> json) => Ecoviolation()
  ..id = json['id'] as int?
  ..title = json['title'] as String?
  ..description = json['description'] as String?
  ..dateFrom = json['dateFrom'] == null
      ? null
      : DateTime.parse(json['dateFrom'] as String)
  ..dateTo =
      json['dateTo'] == null ? null : DateTime.parse(json['dateTo'] as String)
  ..active = json['active'] as bool?
  ..image = json['image'] == null
      ? null
      : Image.fromJson(json['image'] as Map<String, dynamic>)
  ..firstImage = json['firstImage'] == null
      ? null
      : Image.fromJson(json['firstImage'] as Map<String, dynamic>);

Map<String, dynamic> _$EcoviolationToJson(Ecoviolation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'dateFrom': instance.dateFrom?.toIso8601String(),
      'dateTo': instance.dateTo?.toIso8601String(),
      'active': instance.active,
      'image': instance.image,
      'firstImage': instance.firstImage,
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
