import 'dart:convert';
import 'dart:io';

import 'package:elevation_extractor/models/coordinate.dart';

import 'models/elevation.dart';
import 'models/rectangle.dart';

// ignore: constant_identifier_names
const ELEVATION_THRESHHOLD = 100;
// ignore: constant_identifier_names
const DEM_PATH =
    '/Users/skandar/Desktop/random-forest/elevation_project/GTOPO_30/GTOPO30.tif';
Future<void> main() async {
  print("Started");
  List<Rectangle> processedRect = [];

  List<Rectangle> divideRectangle(Rectangle rectangle) {
    List<Rectangle> result = [];
    final xMin = rectangle.min.lon;
    final yMin = rectangle.min.lat;
    final xMax = rectangle.max.lon;
    final yMax = rectangle.max.lat;

    var width = xMax - xMin;
    var height = yMax - yMin;
    var widthHalf = (xMin + xMax) / 2;
    var heightHalf = (yMin + yMax) / 2;

    if (width >= height * 2) {
      // print("vertically");
      result
          .add(Rectangle(Coordinate(xMin, yMin), Coordinate(widthHalf, yMax)));
      result
          .add(Rectangle(Coordinate(widthHalf, yMin), Coordinate(xMax, yMax)));
    } else {
      // print("Horizontally");
      result
          .add(Rectangle(Coordinate(xMin, yMin), Coordinate(xMax, heightHalf)));
      result
          .add(Rectangle(Coordinate(xMin, heightHalf), Coordinate(xMax, yMax)));
    }

    return result;
  }

  Future<Elevation> getElevation(Rectangle rectangle) async {
    Elevation result = Elevation(-32768.0, -32768.0);
    final gdalCommand = [
      '-q',
      '-of',
      'XYZ',
      '-projwin',
      rectangle.min.lon.toString(),
      rectangle.max.lat.toString(),
      rectangle.max.lon.toString(),
      rectangle.min.lat.toString(), //  <xmin> <ymax> <xmax> <ymin>
      DEM_PATH,
      '/vsistdout/',
    ];

    try {
      final processResult = await Process.run('gdal_translate', gdalCommand);
      if (processResult.exitCode == 0) {
        final outputLines = LineSplitter.split(processResult.stdout.toString());
        final elevations = <double>[];

        for (final line in outputLines) {
          final parts = line.split(' ');
          if (parts.length >= 3) {
            final elevation = double.tryParse(parts[2]);
            if (elevation != null) {
              elevations.add(elevation);
            }
          }
        }

        if (elevations.isNotEmpty) {
          elevations.sort();
          final minElevation = elevations.first;
          final maxElevation = elevations.last;

          result = Elevation(
            minElevation == -32768.0 ? 0 : minElevation,
            maxElevation == -32768.0 ? 0 : maxElevation,
          );
        } else {
          print('No elevation data found in the subset.');
        }
      } else {
        final error = processResult.stderr;
        print('Error: $error');
      }
    } catch (error) {
      print('Error: $error');
    }

    return result;
  }

  Future<void> processRectangle(Rectangle rectangle) async {
    final elevation = await getElevation(rectangle);

    if (elevation.max - elevation.min > ELEVATION_THRESHHOLD) {
      var x = divideRectangle(rectangle)
          .map((r) async => await processRectangle(r))
          .toList();

      await x.first;
      await x.last;
    } else {
      rectangle.elevation = elevation;
      processedRect.add(rectangle);
    }
  }

  String listToGeoJson(List<Rectangle> rectangles) {
    final featureCollection = {
      "type": "FeatureCollection",
      "features": rectangles.map((rect) => rect.toGeoJsonFeature()).toList(),
    };

    return json.encode(featureCollection);
  }

  List<Rectangle> cartesianRectangles = [
    // Rectangle(Coordinate(0, 0), Coordinate(8, 6)),
    Rectangle(Coordinate(0, 0), Coordinate(180, 90)),
    Rectangle(Coordinate(0, 0), Coordinate(180, -90)),
    Rectangle(Coordinate(0, 0), Coordinate(-180, -90)),
    Rectangle(Coordinate(0, 0), Coordinate(-180, 90)),
  ];

  for (int i = 0; i < cartesianRectangles.length; i++) {
    try {
      await processRectangle(cartesianRectangles[i]);

      // List<Map<String, dynamic>> jsonList =
      //     processedRect.map((rect) => rect.toJson()).toList();

      // String jsonString = json.encode(jsonList);
      // print(jsonString);
    } catch (e) {
      print('Exception: $e');
    }
  }
  String geoJson = listToGeoJson(processedRect);
  var file = File(
      './lib/result/GeoJson_${DateTime.now().millisecondsSinceEpoch}.json');
  file.writeAsStringSync(geoJson);

  List<Map<String, dynamic>> jsonList =
      processedRect.map((rect) => rect.toJson()).toList();

  String jsonString = json.encode(jsonList);

  file =
      File('./lib/result/Rect_${DateTime.now().millisecondsSinceEpoch}.json');
  file.writeAsStringSync(jsonString);
  print("Done");
}
