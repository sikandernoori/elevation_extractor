import 'dart:convert';
import 'dart:io';
import 'dart:math' show cos, sqrt, asin, pow, sin, pi, atan2;

import 'package:elevation_extractor/models/coordinate.dart';
import 'package:elevation_extractor/tiff_reader.dart';

import 'models/elevation.dart';
import 'models/rectangle.dart';
import 'models/utils.dart';

// ignore: constant_identifier_names
const ELEVATION_THRESHHOLD = 100;
// ignore: constant_identifier_names
const DEM_PATH =
    '/Users/skandar/Desktop/random-forest/elevation_project/GTOPO_30/GTOPO30.tif';
Future<void> main() async {
  Stopwatch sw1 = Stopwatch()..start();
  print("Started at ${DateTime.now()}");

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double getArea(Coordinate coord1, Coordinate coord2) {
    const earthRadius = 6371.0; // Earth's radius in kilometers

    double dLat = (coord2.lat - coord1.lat) * pi / 180.0;
    double dLng = (coord2.lon - coord1.lon) * pi / 180.0;

    double a = pow(sin(dLat / 2), 2) +
        cos(coord1.lat * pi / 180.0) *
            cos(coord2.lat * pi / 180.0) *
            pow(sin(dLng / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c; // Area in square kilometers
  }

  Future<bool> divideTiff(Point startPoint, Point endPoint) async {
    Stopwatch sw = Stopwatch()..start();
    final width = endPoint.row - startPoint.row;
    var height = endPoint.col - startPoint.col;
    var fileName = "x + (y * height)";

    final gdalCommand = [
      '-of',
      'GTiff',
      '-srcwin',
      startPoint.row.toString(),
      startPoint.col.toString(),
      width.toString(),
      height.toString(), //  <xoff> <yoff> <xsize> <ysize>
      DEM_PATH,
      '$fileName.tiff',
    ];

    try {
      final processResult = await Process.run('gdal_translate', gdalCommand,
          workingDirectory: './lib/data_set/');
      if (processResult.exitCode == 0) {
        // Successfully file created
        return true;
      } else {
        final error = processResult.stderr;
        print('Error: $error');
        return false;
      }
    } catch (error) {
      print('Error: $error');
      return false;
    }
  }

  // var i = 0;

  for (double long = -180; long <= 180; long = long + 2) {
    for (double lat = 90; lat >= -90; lat--) {
      // print('Long $long , Lat $lat');

      await divideTiff(
        Point(Utils.longitudeToColumn(long), Utils.latitudeToRow(lat)),
        Point(Utils.longitudeToColumn(long + 2), Utils.latitudeToRow(lat - 1)),
      );
      // i++;
    }
  }
  // await divideTiff('123', Point(3000, 2100), 1200, 300);
}

class Point {
  int row;
  int col;
  Point(this.row, this.col);
}
