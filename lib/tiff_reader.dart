import 'dart:io';
import 'package:image/image.dart';
import 'package:image/image.dart' as img;

import 'models/utils.dart';

void main() {
  double latitude = 42.073850;
  double longitude = 13.029003;
  print("Started at ${DateTime.now()}");
  Stopwatch sw = Stopwatch()..start();
  var tiffFile = File(
      '/Users/skandar/Desktop/random-forest/elevation_project/GTOPO_30/GTOPO30.tif');
  var bytes = tiffFile.readAsBytesSync();
  var image = TiffDecoder().decode(bytes);

  ///
  /// To crop image.
  ///
  // var minX = Utils.longitudeToColumn(-155);
  // var minY = Utils.latitudeToRow(72.5);
  // var maxX = Utils.longitudeToColumn(-145);
  // var maxY = Utils.latitudeToRow(67.5);
  // var iImage = copyCrop(image!, x: minX, y: minY, width: 5000, height: 7000);
  // var tiff = encodeTiff(iImage);
  // File('image.tiff').writeAsBytesSync(tiff);

  print('Tiff load time ${sw.elapsedMilliseconds} ms');
  sw.reset();

  var col = Utils.longitudeToColumn(longitude);
  var row = Utils.latitudeToRow(latitude);
  var elevation = image?.data?.getPixel(col, row).r.toDouble();

  print(
      'Elevation: $elevation | Time: ${sw.elapsedMicroseconds} micro seconds');

  print("Ended at ${DateTime.now()}");
}


/// 0: [-155,67.5]
/// 1: [-145,67.5]
/// 2: [-145,72.5]
/// 3: [-155,72.5]
/// 4: [-155,67.5]