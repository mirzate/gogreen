//import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'event.g.dart';

@JsonSerializable()
class Event {
  int? id;
  String? title;
  String? description;
  String? dateFrom;
  String? dateTo;
  bool? active;
  EventType? eventType; // Property for the nested EventType
  Municipality? municipality;
  List<EventImage>? images;
  EventImage? firstImage;

  Event();

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

  factory EventType.fromJson(Map<String, dynamic> json) =>
      _$EventTypeFromJson(json);
  Map<String, dynamic> toJson() => _$EventTypeToJson(this);
}

@JsonSerializable()
class Municipality {
  int? id;
  String? title;
  String? description;
  bool? active;

  Municipality();

  factory Municipality.fromJson(Map<String, dynamic> json) =>
      _$MunicipalityFromJson(json);
  Map<String, dynamic> toJson() => _$MunicipalityToJson(this);
}

@JsonSerializable()
class EventImage {
  int? id;
  String? fileName;
  String? filePath;

  EventImage();

  factory EventImage.fromJson(Map<String, dynamic> json) =>
      _$EventImageFromJson(json);
  Map<String, dynamic> toJson() => _$EventImageToJson(this);
}


/*
"items": [
{
  "id": 6,
  "title": "ert",
  "description": "ert",
  "dateFrom": "2023-01-01T00:00:00",
  "dateTo": "2023-01-01T00:00:00",
  "active": true,
  "eventType": {
    "id": 2,
    "name": "Akcija čišćenja"
  },
  "municipality": {
    "id": 2,
    "title": "xxx",
    "description": "testtest",
    "active": true
  },
  "images": [],
  "firstImage": null
}
  ]
*/