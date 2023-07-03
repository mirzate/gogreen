//import 'dart:ffi';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'green_island.g.dart';

@JsonSerializable()
class GreenIsland{
  int? id;
  String? title;
  String? description;
  double? longitude;
  double? latitude;
  Municipality? municipality;
  List<Image>? images;
  Image? firstImage;

  GreenIsland();

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory GreenIsland.fromJson(Map<String, dynamic> json) => _$GreenIslandFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$GreenIslandToJson(this);

}

@JsonSerializable()
class Municipality {
  int? id;
  String? title;
  String? description;

  Municipality();

  factory Municipality.fromJson(Map<String, dynamic> json) => _$MunicipalityFromJson(json);
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


