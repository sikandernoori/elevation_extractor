import 'dart:io';
import 'package:image/image.dart';

void main() {
  print("Started at ${DateTime.now()}");
  Stopwatch sw = Stopwatch()..start();
  var tiffFile = File(
      '/Users/skandar/Desktop/random-forest/elevation_project/GTOPO_30/GTOPO30.tif');
  var bytes = tiffFile.readAsBytesSync();
  var tiffDecoder = TiffDecoder();
  var image = tiffDecoder.decode(bytes);

  print('Tiff load time ${sw.elapsedMilliseconds} ms');
  sw.reset();

  var col = Utils.longitudeToColumn(11.099049);
  var row = Utils.latitudeToRow(47.044112);
  var elevation = image?.data?.getPixel(col, row).r.toDouble();

  print(
      'Elevation: $elevation | Time: ${sw.elapsedMicroseconds} micro seconds');

  print("Ended at ${DateTime.now()}");
}

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
}
