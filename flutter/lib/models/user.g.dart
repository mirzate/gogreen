// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User()
  ..id = json['id'] as String?
  ..email = json['email'] as String?
  ..isApproved = json['isApproved'] as bool?
  ..municipality = json['municipality'] == null
      ? null
      : Municipality.fromJson(json['municipality'] as Map<String, dynamic>)
  ..roles = json['roles'] as List<dynamic>?;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'isApproved': instance.isApproved,
      'municipality': instance.municipality,
      'roles': instance.roles,
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
