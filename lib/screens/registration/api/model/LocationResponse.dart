class LocationResponse {
  String? location;
  Position? position;

  LocationResponse({this.location, this.position});

  factory LocationResponse.fromJSON(Map<String, dynamic> parsedJson) {
    return LocationResponse(
        location: parsedJson['location'],
        position: Position.fromJson(parsedJson['position']));
  }

  // LocationResponse.fromJSON(String jsonString) {
  //   print(jsonString);
  //   Map<String, dynamic> jsonMap = jsonDecode(jsonString);
  //   print(jsonMap["location"]);
  //   this.location = jsonMap["location"];
  //   print(jsonMap["position"]);
  //   this.position = Position.fromJSON(jsonMap["position"]);
  // }

}

class Position {
  double? lat;
  double? lng;

  Position({this.lat, this.lng});

  // Position.fromJSON(String jsonString) {
  //   Map<String, dynamic> jsonMap = jsonDecode(jsonString);

  //   this.lat = jsonMap["lat"];
  //   this.lng = jsonMap["lng"];

  // }
  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      lat: json['lat'],
      lng: json['lng']
    );
  }
}
