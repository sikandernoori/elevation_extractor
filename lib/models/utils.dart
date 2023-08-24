import 'dart:io';

import 'package:image/image.dart';

class Utils {
  static int longitudeToColumn(double longitude) {
    // 360 long = 43200 columns
    // 1 long = 43200/360
    // x long = (43200/360) * x
    // 43200 columns = 360
    // 1 column = 360/43200
    // 1 column = 0.0083333 long

    const double columnsPerDegree = 43200 / 360;
    return (columnsPerDegree * (longitude + 180)).toInt();
  }

  static int latitudeToRow(double latitude) {
    // 180 lat = 21600 columns
    // 1 lat = 21600/180
    // x lat = (21600/180) * x
    // 21600 column = 180 lat
    // 1 column = 180/21600
    // 1 column = 0.0083333 lat

    const double rowsPerDegree = 21600 / 180;
    return (rowsPerDegree * (90 - latitude)).toInt();
  }

  static Image getImageFromIndex(int index) {
    var tiffFile = File(
        '/Users/skandar/Desktop/random-forest/elevation_project/elevation_extractor/lib/data_set_compressed/$index.tiff');
    return TiffDecoder().decode(tiffFile.readAsBytesSync())!;
  }

  static int roundToPrevious10th(int value) {
    if (value >= 0) {
      return (value ~/ 10) * 10;
    } else {
      return ((value - 9) ~/ 10) * 10;
    }
  }

  static int roundToPrevious5th(int value) {
    if (value >= 0) {
      return (value ~/ 5) * 5;
    } else {
      return ((value - 4) ~/ 5) * 5;
    }
  }

  static int roundToNext5th(double value) {
    if (value >= 0) {
      return ((value + 4).ceil() ~/ 5) * 5;
    } else {
      return (value ~/ 5) * 5;
    }
  }
}
