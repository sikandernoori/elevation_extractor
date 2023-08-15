class Coordinate {
  double lon;
  double lat;
  Coordinate(this.lon, this.lat);

  Map<String, dynamic> toJson() {
    return {
      'lon': lon,
      'lat': lat,
    };
  }
}
