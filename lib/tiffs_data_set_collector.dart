import 'dart:convert';
import 'dart:io';
import 'dart:math' show cos, sqrt, asin, pow, sin, pi, atan2;

import 'package:elevation_extractor/models/coordinate.dart';
import 'package:elevation_extractor/tiff_reader.dart';
import 'package:geojson_vi/geojson_vi.dart';

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

  Future<bool> divideTiff(int index, Point startPoint, Point endPoint) async {
    Stopwatch sw = Stopwatch()..start();
    final width = endPoint.row - startPoint.row;
    final height = (endPoint.col - startPoint.col).abs();

    final gdalCommand = [
      '-co',
      'compress=lzw',
      '-of',
      'GTiff',
      '-srcwin',
      startPoint.row.toString(),
      startPoint.col.toString(),
      width.toString(),
      height.toString(), //  <xoff> <yoff> <xsize> <ysize>
      DEM_PATH,
      '$index.tiff',
    ];

    // print('gdal_translate $gdalCommand');
    // return true;

    try {
      final processResult = await Process.run('gdal_translate', gdalCommand,
          workingDirectory: './lib/xml_only/');
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

  // var dLon = 10;
  // var dLat = 5;
  // var height = 180;
  // var width = 360;

  // for (var lat = -90; lat < 90; lat += dLat) {
  //   for (var lon = -180; lon < 180; lon += dLon) {
  //     var index = ((lon + (width / 2)) / dLon).floor() +
  //         (((lat + (height / 2)) / dLat) * (height / dLat)).floor();

  //     await divideTiff(
  //         index,
  //         Point(Utils.longitudeToColumn(lon.toDouble()),
  //             Utils.latitudeToRow(lat.toDouble())),
  //         Point(Utils.longitudeToColumn((lon + dLon).toDouble()),
  //             Utils.latitudeToRow((lat + dLat).toDouble())));
  //   }
  // }

  String jsonData =
      File('lib/elevation-indexed-10x5.geojson').readAsStringSync();

  var geoJson = GeoJSONFeatureCollection.fromJSON(jsonData);

  for (var feature in geoJson.features) {
    var coords = feature?.geometry.bbox;
    int index = feature?.properties?['index'];
    print(index);
    if (coords != null) {
      var startPoint = Point(Utils.longitudeToColumn(coords[0]).toInt(),
          Utils.latitudeToRow(coords[3]).toInt());
      var endPoint = Point(Utils.longitudeToColumn(coords[2]).toInt(),
          Utils.latitudeToRow(coords[1]).toInt());

      await divideTiff(index, startPoint, endPoint);
      // print(index);
    } else {
      print("???");
    }
  }

  print(geoJson.features.length);

  // await divideTiff('123', Point(3000, 2100), 1200, 300);
}

class Point {
  int row;
  int col;
  Point(this.row, this.col);
}
