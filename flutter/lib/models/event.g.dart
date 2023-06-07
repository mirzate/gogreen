// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      json['id'] as int?,
      json['title'] as String?,
      json['description'] as String?,
      json['dateFrom'] == null
          ? null
          : DateTime.parse(json['dateFrom'] as String),
    )
      ..dateTo = json['dateTo'] == null
          ? null
          : DateTime.parse(json['dateTo'] as String)
      ..active = json['active'] as bool?
      ..eventType = json['eventType'] == null
          ? null
          : EventType.fromJson(json['eventType'] as Map<String, dynamic>)
      ..municipalityType = json['municipalityType'] == null
          ? null
          : MunicipalityType.fromJson(
              json['municipalityType'] as Map<String, dynamic>)
      ..image = json['image'] == null
          ? null
          : Image.fromJson(json['image'] as Map<String, dynamic>);

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'dateFrom': instance.dateFrom?.toIso8601String(),
      'dateTo': instance.dateTo?.toIso8601String(),
      'active': instance.active,
      'eventType': instance.eventType,
      'municipalityType': instance.municipalityType,
      'image': instance.image,
    };

EventType _$EventTypeFromJson(Map<String, dynamic> json) => EventType()
  ..id = json['id'] as int?
  ..name = json['name'] as String?;

Map<String, dynamic> _$EventTypeToJson(EventType instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

MunicipalityType _$MunicipalityTypeFromJson(Map<String, dynamic> json) =>
    MunicipalityType()
      ..id = json['id'] as int?
      ..title = json['title'] as String?
      ..description = json['description'] as String?
      ..active = json['active'] as bool?;

Map<String, dynamic> _$MunicipalityTypeToJson(MunicipalityType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'active': instance.active,
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
