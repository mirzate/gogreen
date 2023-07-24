//import 'dart:ffi';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'eco_violation.g.dart';

@JsonSerializable()
class Ecoviolation {
  int? id;
  String? title;
  String? description;
  String? contact;
  String? response;
  //EcoviolationType? EcoviolationType; // Property for the nested EcoViolationType
  Municipality? municipality;
  List<Image>? images;
  Image? firstImage;

  Ecoviolation();

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Ecoviolation.fromJson(Map<String, dynamic> json) =>
      _$EcoviolationFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$EcoviolationToJson(this);
}

/*
@JsonSerializable()
class EcoviolationType {
  int? id;
  String? name;

  EcoviolationType();

  factory EcoviolationType.fromJson(Map<String, dynamic> json) => _$EcoviolationTypeFromJson(json);
  Map<String, dynamic> toJson() => _$EcoviolationTypeToJson(this);
}
*/

@JsonSerializable()
class Municipality {
  int? id;
  String? title;
  String? description;

  Municipality();

  factory Municipality.fromJson(Map<String, dynamic> json) =>
      _$MunicipalityFromJson(json);
  Map<String, dynamic> toJson() => _$MunicipalityToJson(this);
}

@JsonSerializable()
class Image {
  int? id;
  String? fileName;
  String? filePath;

  Image();

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
  Map<String, dynamic> toJson() => _$ImageToJson(this);
}
