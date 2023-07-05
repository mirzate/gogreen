// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eco_violation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ecoviolation _$EcoviolationFromJson(Map<String, dynamic> json) => Ecoviolation()
  ..id = json['id'] as int?
  ..title = json['title'] as String?
  ..description = json['description'] as String?
  ..contact = json['contact'] as String?
  ..response = json['response'] as String?
  ..municipality = json['municipality'] == null
      ? null
      : Municipality.fromJson(json['municipality'] as Map<String, dynamic>)
  ..images = (json['images'] as List<dynamic>?)
      ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
      .toList()
  ..firstImage = json['firstImage'] == null
      ? null
      : Image.fromJson(json['firstImage'] as Map<String, dynamic>);

Map<String, dynamic> _$EcoviolationToJson(Ecoviolation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'contact': instance.contact,
      'response': instance.response,
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
