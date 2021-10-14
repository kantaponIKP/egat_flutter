class LocationResponse {
  String? location;
  num? zoomLevel;
  Position? position;

  LocationResponse({this.location, this.zoomLevel, this.position});

  factory LocationResponse.fromJSON(Map<String, dynamic> parsedJson) {
    return LocationResponse(
        location: parsedJson['location'],
        zoomLevel: parsedJson['zoomLevel'],
        position: Position.fromJson(parsedJson['position']));  
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
