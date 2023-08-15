import 'package:elevation_extractor/models/coordinate.dart';
import 'package:elevation_extractor/models/elevation.dart';

class Rectangle {
  Coordinate min;
  Coordinate max;

  Elevation? elevation;

  Rectangle(this.min, this.max, {this.elevation});

  Map<String, dynamic> toJson() {
    return {
      'min': min.toJson(),
      'max': max.toJson(),
      'elevation': elevation?.toJson(),
    };
  }

  Map<String, dynamic> toGeoJsonFeature() {
    return {
      "type": "Feature",
      "properties": {
        "elevation": {
          "min": elevation?.min ?? 0.0,
          "max": elevation?.max ?? 0.0,
        },
      },
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [min.lon, min.lat],
            [max.lon, min.lat],
            [max.lon, max.lat],
            [min.lon, max.lat],
            [min.lon, min.lat],
          ],
        ],
      },
    };
  }
}
