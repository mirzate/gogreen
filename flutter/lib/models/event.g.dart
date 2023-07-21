// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event()
  ..id = json['id'] as int?
  ..title = json['title'] as String?
  ..description = json['description'] as String?
  ..dateFrom = json['dateFrom'] as String?
  ..dateTo = json['dateTo'] as String?
  ..active = json['active'] as bool?
  ..eventType = json['eventType'] == null
      ? null
      : EventType.fromJson(json['eventType'] as Map<String, dynamic>)
  ..municipality = json['municipality'] == null
      ? null
      : Municipality.fromJson(json['municipality'] as Map<String, dynamic>)
  ..images = (json['images'] as List<dynamic>?)
      ?.map((e) => EventImage.fromJson(e as Map<String, dynamic>))
      .toList()
  ..firstImage = json['firstImage'] == null
      ? null
      : EventImage.fromJson(json['firstImage'] as Map<String, dynamic>);

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'dateFrom': instance.dateFrom,
      'dateTo': instance.dateTo,
      'active': instance.active,
      'eventType': instance.eventType,
      'municipality': instance.municipality,
      'images': instance.images,
      'firstImage': instance.firstImage,
    };

EventType _$EventTypeFromJson(Map<String, dynamic> json) => EventType()
  ..id = json['id'] as int?
  ..name = json['name'] as String?;

Map<String, dynamic> _$EventTypeToJson(EventType instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

Municipality _$MunicipalityFromJson(Map<String, dynamic> json) => Municipality()
  ..id = json['id'] as int?
  ..title = json['title'] as String?
  ..description = json['description'] as String?
  ..active = json['active'] as bool?;

Map<String, dynamic> _$MunicipalityToJson(Municipality instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'active': instance.active,
    };

EventImage _$EventImageFromJson(Map<String, dynamic> json) => EventImage()
  ..id = json['id'] as int?
  ..fileName = json['fileName'] as String?
  ..filePath = json['filePath'] as String?;

Map<String, dynamic> _$EventImageToJson(EventImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fileName': instance.fileName,
      'filePath': instance.filePath,
    };
