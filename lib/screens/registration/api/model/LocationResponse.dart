import 'dart:convert';

class LocationResponse {
  String? location;
  num? zoomLevel;
  Position? position;

  LocationResponse({this.location, this.zoomLevel, this.position});

  LocationResponse.fromJSON(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    this.location = jsonMap["location"];
    this.zoomLevel = jsonMap["zoomLevel"];
    this.position = Position.fromJson(jsonMap["position"]);
  }

}
class Position {
  num? lat;
  num? lng;

  Position({this.lat, this.lng});

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      lat: json['lat'],
      lng: json['lng']
    );
  }
}