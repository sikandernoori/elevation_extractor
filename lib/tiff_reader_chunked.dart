import 'models/utils.dart';

void main() {
  double lat = 35.881866;
  double lon = 76.513240;
  print("Started at ${DateTime.now()}");
  Stopwatch sw = Stopwatch()..start();

  var colAbsolute = Utils.longitudeToColumn(lon);
  var rowAbsolute = Utils.latitudeToRow(lat);
  var longss = Utils.roundToPrevious10th(lon.floor()).toDouble();
  var colOffset = Utils.longitudeToColumn(longss);
  var latss = Utils.roundToNext5th(lat).toDouble();
  var rowOffset = Utils.latitudeToRow(latss);
  var dLon = 10;
  var dLat = 5;
  var height = 180;
  var width = 360;

  var index =
      ((Utils.roundToPrevious10th(lon.floor()) + (width / 2)) / dLon).floor() +
          (((Utils.roundToPrevious5th(lat.floor()) + (height / 2)) / dLat) *
                  (height / dLat))
              .floor();

  var image = Utils.getImageFromIndex(index);
  var elevation = image.data
      ?.getPixel(colAbsolute - colOffset, (rowAbsolute - rowOffset).abs())
      .r
      .toDouble();

  print('Elevation: $elevation | Time: ${sw.elapsedMilliseconds} ms');

  print("Ended at ${DateTime.now()}");
}
