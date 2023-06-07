import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'event.g.dart';

@JsonSerializable()
class Event{
  int? id;
  String? title;
  String? description;
  DateTime? dateFrom;
  DateTime? dateTo;
  bool? active;
  EventType? eventType; // Property for the nested EventType
  MunicipalityType? municipalityType;
  Image? image;
  //String? base64Data = 'SGVsbG8gV29ybGQh'; // Replace with your base64-encoded data

  Event(this.id, this.title, this.description, this.dateFrom);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$EventToJson(this);

}

@JsonSerializable()
class EventType {
  int? id;
  String? name;

  EventType();

  factory EventType.fromJson(Map<String, dynamic> json) => _$EventTypeFromJson(json);
  Map<String, dynamic> toJson() => _$EventTypeToJson(this);
}


@JsonSerializable()
class MunicipalityType {
  int? id;
  String? title;
  String? description;
  bool? active;

  MunicipalityType();

  factory MunicipalityType.fromJson(Map<String, dynamic> json) => _$MunicipalityTypeFromJson(json);
  Map<String, dynamic> toJson() => _$MunicipalityTypeToJson(this);
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


/*
"items": [
            {
                "id": 0,
                "title": "string",
                "description": "string",
                "dateFrom": "2023-06-06T19:51:36.537Z",
                "dateTo": "2023-06-06T19:51:36.537Z",
                "active": true,
                "eventType": {
                  "id": 0,
                  "name": "string"
                },
                "municipality": {
                  "id": 0,
                  "title": "string",
                  "description": "string",
                  "active": true
                },
                "images": [
                  {
                    "id": 0,
                    "fileName": "string",
                    "filePath": "string"
                  }
                ]
              }
  ]
*/