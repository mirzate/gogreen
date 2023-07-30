// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      email: json['email'],
      id: json['id'],
      municipality: json['municipality'] == null
          ? null
          : Municipality.fromJson(json['municipality'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'municipality': instance.municipality,
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
