import 'dart:io';
import 'package:geojson_vi/geojson_vi.dart';
import 'models/utils.dart';

// ignore: constant_identifier_names
const DEM_PATH =
    '/Users/skandar/Desktop/random-forest/elevation_project/GTOPO_30/GTOPO30.tif';
Future<void> main() async {
  Stopwatch sw1 = Stopwatch()..start();

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
          workingDirectory: './lib/4x2/');
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

  String jsonData =
      File('lib/elevation-indexed-4x2.geojson').readAsStringSync();

  var geoJson = GeoJSONFeatureCollection.fromJSON(jsonData);

  for (var feature in geoJson.features) {
    var coords = feature?.geometry.bbox;
    int index = feature?.properties?['index'];
    print(index);
    if (coords != null) {
      var startLong = Utils.longitudeToColumn(coords[0]).toInt();
      var endLong = Utils.longitudeToColumn(coords[2]).toInt();

      var startLat = Utils.latitudeToRow(coords[3]).toInt();
      var endLat = Utils.latitudeToRow(coords[1]).toInt();

      var startPoint = Point(startLong, startLat);
      var endPoint = Point(endLong, endLat);

      await divideTiff(index, startPoint, endPoint);
    } else {
      print("???");
    }
  }

  print(geoJson.features.length);
  print('Took: ${sw1.elapsedMilliseconds}ms');
}

class Point {
  int row;
  int col;
  Point(this.row, this.col);
}
